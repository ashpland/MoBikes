struct World {
    var stationApi: StationApi = .live
    var locationClient: LocationClient = .live
    var locationClientDelegate: LocationClient.Delegate? = nil
}

extension World {
    static let mock = World(stationApi: .mock, locationClient: .lostLagoon)
}
