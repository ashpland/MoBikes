struct watchState: StateManageable {
    var activeError: MBError? = nil
    var currentLocation: Coordinate = .cityHall
    var region: Region = .start
    var stations: [Station] = []
    var world: World = World()
    
    var navigation: Navigation = .list
    
    enum Event {
        case navigate(Navigation)
    }
    static func handleEvent(state: Self, event: Event) throws -> Self {
        switch event {
        case .navigate(let next):
            return assoc(state, \.navigation, next)
        }
    }
    
    enum AsyncEvent {}
    static func handleAsyncEvent(state: Self, event: AsyncEvent) async throws-> (Self) -> Self {}
}

extension watchState {
    enum Navigation {
        case list
        case map
    }
}
