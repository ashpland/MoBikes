import Foundation

struct World {
    var stationApi = StationApi()
    var tests = TestSettings()
}

extension World {
    static let mock = World(stationApi: .mock, tests: .mock)
}

struct StationApi {
    var getStations: () async throws -> [Station] = getStationsLive
}

private func getStationsLive() async throws -> [Station] {
    let apiURL = URL(string: "https://vancouver-ca.smoove.pro/api-public/stations")!
    return try await apiURL
    |> dataRequestForURL
    >>> second(asType(HTTPURLResponse.self))
    >>> checkStatus
    >>> decode(DecodableStation.Group.self)
    >>> ^\.result
    >>> compactMap(Station.init(decoded:))
}

extension StationApi {
    static let live = StationApi()
    static let mock = StationApi { Station.examples }
    static func random(_ count: Int = 250) -> StationApi {
        StationApi { Array(1...count).map { _ in Station.random() }}
    }
}

struct TestSettings {
    var enableTests = false
    var showFullScreen = false
}

extension TestSettings {
    static let mock = TestSettings(enableTests: true, showFullScreen: false)
}
