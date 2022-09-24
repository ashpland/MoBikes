import MapKit
import SwiftUI

class StateManager<DB: StateManageable>: ObservableObject {
    @Published private(set) var db: DB
    
    init(_ db: DB) {
        self.db = db
    }
    
    func dispatch(_ event: Event) {
        do {
            self.db = try Self.handleEvent(state: self.db, event: event)
        } catch {
            setActiveError(error)
        }
    }
    
    func dispatchAsync(_ event: AsyncEvent) {
        Task {
            do {
                let db = try await Self.handleAsyncEvent(state: self.db, event: event)
                await MainActor.run {
                    self.db = db
                }
            } catch {
                setActiveError(error)
            }
        }
    }
    
    private func setActiveError(_ error: Error) {
        self.db = assoc(db, \.activeError, MBError.from(error: error))
    }
}

extension StateManager {
    enum Event {
        case custom(DB.Event)
        case clearError
        case throwSampleError
        case toLostLagoon
        case updateRegion(MKCoordinateRegion)
    }
}

extension StateManager {
    static func handleEvent(state: DB, event: Event) throws -> DB {
        switch event {
        case .custom(let customEvent):
            return try DB.handleEvent(state: state, event: customEvent)
        case .clearError:
            return assoc(state, \.activeError, nil)
        case .throwSampleError:
            return assoc(state, \.activeError, .decoderError)
        case .toLostLagoon:
            return assoc(state, \.region, Coordinate.lostLagoon.region())
        case .updateRegion (let region):
            guard let region = Region(region) else { return state }
            return assoc(state, \.region, region)
        }
    }
}

extension StateManager {
    enum AsyncEvent {
        case custom(DB.AsyncEvent)
        case updateStations
    }
}

extension StateManager {
    static func handleAsyncEvent(state: DB, event: AsyncEvent) async throws -> DB {
        switch event {
        case .custom(let customEvent):
            return try await DB.handleAsyncEvent(state: state, event: customEvent)
        case .updateStations:
            let stations = try await state.world.stationApi.getStations()
            return assoc(state, \.stations, stations)
        }
    }
}

protocol StateManageable {
    associatedtype Event
    static func handleEvent(state: Self, event: Event) throws -> Self
    associatedtype AsyncEvent
    static func handleAsyncEvent(state: Self, event: AsyncEvent) async throws -> Self
    
    var activeError: MBError? { get set }
    var region: Region { get set }
    var stations: [Station] { get set }
    var world: World { get set }
}
