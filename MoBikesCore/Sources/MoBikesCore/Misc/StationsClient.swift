import Combine
import Foundation

public struct StationsClient {
    public var updateStations: () -> Void
    public var results: AnyPublisher<[Station], Error>
    
    public init(updateStations: @escaping () -> Void, results: AnyPublisher<[Station], Error>) {
        self.updateStations = updateStations
        self.results = results
    }
}

extension StationsClient {
    public static var live: StationsClient {
        let apiURL = URL(string: "https://vancouver-ca.smoove.pro/api-public/stations")!
        let requestStations = CurrentValueSubject<Void, Never>(())
        return Self.init(
            updateStations: { requestStations.send(()) },
            results: requestStations
                // TODO: Figure out appropriate api throttle
                .throttle(for: 6, scheduler: RunLoop.main, latest: true)
                .flatMap { URLSession.shared.dataTaskPublisher(for: apiURL) }
                .map { data, _ in data }
                .decode(type: Station.Group.self, decoder: JSONDecoder())
                .map(\.stations)
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        )
    }
}

extension StationsClient {
    public static var mock: StationsClient {
        let requestStations = CurrentValueSubject<Void, Never>(())
        return Self.init(
            updateStations: { requestStations.send(()) },
            results: requestStations
                .flatMap { Just(Station.examples) }
                .receive(on: DispatchQueue.main)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        )
    }
}
