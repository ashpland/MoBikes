struct watchState: StateManageable {
    var activeError: MBError? = nil
    var currentLocation: Coordinate = .cityHall
    var stations: [Station] = []
    var world: World = World()
        
    enum Event { }
    static func handleEvent(state: Self, event: Event) throws -> Self { }
    
    enum AsyncEvent: Hashable {}
    static func handleAsyncEvent(state: Self, event: AsyncEvent) async throws-> (Self) -> Self {}
}
