struct iosState: StateManageable {
    var activeError: MBError? = nil
    var currentLocation: Coordinate = .cityHall
    var region: Region = .start
    var stations: [Station] = []
    var world: World = World()
    
    var bikeways: [Bikeway] = []
    
    enum Event {
        case loadBikeways
    }
    
    static func handleEvent(state: Self, event: Event) throws -> Self {
        switch event {
        case .loadBikeways:
            let bikeways = try Bikeway.loadFromFile()
            return assoc(state, \.bikeways, bikeways)
        }
    }
    
    enum AsyncEvent {}
    static func handleAsyncEvent(state: Self, event: AsyncEvent) async throws-> Self {}
}
