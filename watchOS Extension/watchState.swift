struct watchState: StateManageable {
    var activeError: MBError? = nil
    var currentLocation: Coordinate = .cityHall
    var stations: [Station] = []
    var world: World = World()
        
    enum Event { case placeholder }
    static func handleEvent(state: Self, event: Event) throws -> Self { state }
    
    enum AsyncEvent: Hashable { case placeholder }
    static func handleAsyncEvent(state: Self, event: AsyncEvent) async throws-> (Self) -> Self {{ $0 }}
}
