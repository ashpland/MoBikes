import MapKit

struct iosState: StateManageable {
    var activeError: MBError? = nil
    var currentLocation: Coordinate = .cityHall
    var stations: [Station] = []
    var world: World = World()
    
    var region: Region = .cityHall
    var bikeways: [Bikeway] = []
    var ui: UI = UI()
    
    enum Event {
        case loadBikeways
        case zoomToCurrentLocation
        case updateRegion(MKCoordinateRegion)
        case updateUIBool(UI.Update<Bool>)
    }
    
    static func handleEvent(state: Self, event: Event) throws -> Self {
        switch event {
        case .loadBikeways:
            let bikeways = try Bikeway.loadFromFile()
            return assoc(state, \.bikeways, bikeways)
        case .zoomToCurrentLocation:
            return assoc(state, \.region, state.currentLocation.region())
        case .updateRegion (let region):
            guard let region = Region(region) else { return state }
            return assoc(state, \.region, region)
        case .updateUIBool(let uiUpdate):
            return update(state, \.ui, UI.handleUpdate(uiUpdate))
        }
    }
    
    enum AsyncEvent: Hashable {}
    static func handleAsyncEvent(state: Self, event: AsyncEvent) async throws-> (Self) -> Self {}
}

extension iosState {
    struct UI: Equatable {
        var showLayersView = false
        var mapSettings = MapSettings()
        
        struct MapSettings: Equatable {
            var showStations = true
            var showBikeways = true
            var showFountains = false
            var showToilets = false
        }
        
        struct Update<V> {
            let kp: WritableKeyPath<UI, V>
            let value: V
        }
        
        static func handleUpdate<V>(_ update: Update<V>) -> (Self) -> Self {
            return { state in
                return assoc(state, update.kp, update.value)
            }
        }
    }
}
