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
        case updateUIBool(UI.Update<Bool>)
    }
    
    static func handleEvent(state: Self, event: Event) throws -> Self {
        switch event {
        case .loadBikeways:
            let bikeways = try Bikeway.loadFromFile()
            return assoc(state, \.bikeways, bikeways)
        case .zoomToCurrentLocation:
            return state
            |>> assoc(\.region, state.currentLocation.region())
            >>> assoc(\.ui.freezeMap, true)
        case .updateUIBool(let uiUpdate):
            return update(state, \.ui, UI.handleUpdate(uiUpdate))
        }
    }
    
    enum AsyncEvent: Hashable {
        case updateRegion(MKCoordinateRegion)
        case updateUIBool(UI.Update<Bool>)
    }
    static func handleAsyncEvent(state: Self, event: AsyncEvent) async throws-> (Self) -> Self {
        switch event {
        case .updateRegion(let region):
            guard let region = Region(region) else { return identity }
            return assoc(\.region, region)
        case .updateUIBool(let uiUpdate):
            return update(\.ui, UI.handleUpdate(uiUpdate))
        }
    }
}

extension iosState {
    struct UI: Equatable {
        var showLayersView = false
        var freezeMap = false
        var mapSettings = MapSettings()
        
        struct MapSettings: Equatable {
            var showStations = true
            var showBikeways = true
            var showFountains = false
            var showToilets = false
        }
        
        struct Update<V: Hashable>: Hashable {
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
