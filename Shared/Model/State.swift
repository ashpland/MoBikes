import SwiftUI

class StateManager<DB: StateManageable>: ObservableObject {
    @Published private(set) var db: DB
    private var timers: [AsyncEvent:Timer] = [:]
    
    init(_ db: DB) {
        self.db = db
        db.world.locationClient.initialize({ [weak self] in self?.dispatch(.locationEvent($0)) })
    }
    
    func dispatch(_ event: Event) {
        do {
            self.db = try StateManager.handleEvent(state: self.db, event: event)
        } catch {
            setActiveError(error)
        }
    }
    
    func dispatchAsync(_ event: AsyncEvent) {
        Task {
            do {
                let updateDB = try await StateManager.handleAsyncEvent(state: self.db, event: event)
                await MainActor.run {
                    self.dispatch(.update(updateDB))
                }
            } catch {
                setActiveError(error)
            }
        }
    }
    
    func startTimer(_ event: AsyncEvent, seconds: TimeInterval, repeats: Bool = true) {
        self.stopTimer(event)
        let timer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: repeats) { [weak self] _ in
            if let self = self {
                self.dispatchAsync(event)                
            }
        }
        timers[event] = timer
    }
    
    func stopTimer(_ event: AsyncEvent) {
        if let timer = timers[event] {
            timer.invalidate()
            timers.removeValue(forKey: event)
        }
    }
    
    private func setActiveError(_ error: Error) {
        self.db = assoc(db, \.activeError, MBError.from(error: error))
    }
}

extension StateManager {
    enum Event {
        case platform(DB.Event)
        case update((DB) -> DB)
        case clearError
        case throwSampleError
        case locationEvent(LocationClient.Event)
    }
}

extension StateManager {
    static func handleEvent(state: DB, event: Event) throws -> DB {
        switch event {
        case .platform(let customEvent):
            return try DB.handleEvent(state: state, event: customEvent)
        case .update(let updateDB):
            return updateDB(state)
        case .clearError:
            return assoc(state, \.activeError, nil)
        case .throwSampleError:
            return assoc(state, \.activeError, .decoderError)
        case .locationEvent(let locationEvent):
            switch locationEvent {
            case .updateLocation(let location):
                return assoc(state, \.currentLocation, location)
            case .error(let error):
                return assoc(state, \.activeError, .locationError(error))
            case .storeDelegate(let delegate):
                return assoc(state, \.world.locationClientDelegate, delegate)
            }
        }
    }
}

extension StateManager {
    enum AsyncEvent: Hashable {
        case platform(DB.AsyncEvent)
        case updateStations
    }
}

extension StateManager {
    static func handleAsyncEvent(state: DB, event: AsyncEvent) async throws -> (DB) -> DB {
        switch event {
        case .platform(let platformEvent):
            return try await DB.handleAsyncEvent(state: state, event: platformEvent)
        case .updateStations:
            let stations = try await state.world.stationApi.getStations()
            return { assoc($0, \.stations, stations) }
        }
    }
}

protocol StateManageable {
    associatedtype Event
    static func handleEvent(state: Self, event: Event) throws -> Self
    associatedtype AsyncEvent: Hashable
    static func handleAsyncEvent(state: Self, event: AsyncEvent) async throws -> (Self) -> Self
    
    var activeError: MBError? { get set }
    var currentLocation: Coordinate { get set }
    var stations: [Station] { get set }
    var world: World { get set }
}

extension StateManageable {
    var stationsByDistanceFromCurrentLocation: [Station] {
        self.stations.sorted { lhs, rhs in
            lhs.coordinate.distanceFrom(self.currentLocation) < rhs.coordinate.distanceFrom(self.currentLocation)
        }
    }
}
