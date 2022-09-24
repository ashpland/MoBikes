import Combine
import MapKit
import SwiftUI

struct MBState {
    var activeError: MBError? = nil
    var region: Region = .start
    var stations: [Station] = []
    var bikeways: [Bikeway] = []
    var world: World = World()
}

class StateManager: ObservableObject {
    @Published private(set) var state: MBState
    @Published var toggler: Bool = false
    
    init(_ state: MBState) {
        self.state = state
    }
    
    private func update(_ updater: @escaping (MBState) throws -> MBState) {
        do {
            self.state = try state |> updater 
        } catch {
            update(assoc(\.activeError, MBError.from(error: error)))
        }
    }
    
    private func update(_ updater: @escaping (MBState) async throws -> MBState) {
        Task {
            do {
                self.state = try await state |> updater 
            } catch {
                update(assoc(\.activeError, MBError.from(error: error)))
            }
        }
    }
}

extension StateManager {
    func action(_ action: Action) { 
        switch action {
        case .clearError:
            update(assoc(\.activeError, nil))
            
        case .loadBikeways:
            update(assoc(\.bikeways)({ try Bikeway.jsonUrl |> Bikeway.loadFromUrl }))
            
        case .throwSampleError:
            update(assoc(\.activeError, .decoderError))
            
        case .toLostLagoon: 
            update(assoc(\.region, Coordinate.lostLagoon.region()))
            
        case .updateStations:
            update(assoc(\.stations)(state.world.stationApi.getStations))
            
        case .updateRegion (let region):
            if let region = Region(region) {
                update(assoc(\.region, region))
            }
        }
    }
    
    enum Action {
        case clearError
        case loadBikeways
        case toLostLagoon
        case throwSampleError
        case updateStations
        case updateRegion(MKCoordinateRegion)
    }
}

extension StateManager {
    private static let initialState = 
    MBState() 
    |> assoc(\.world.stationApi, .live)
    >>> assoc(\.world.tests, .init(enableTests: true, 
                                   showFullScreen: false))
    
    static let shared = StateManager(initialState)
}
