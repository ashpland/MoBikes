import Combine
import CoreLocation
import Foundation
import LocationClient
import MapKit
import SwiftUI

public final class StationsViewModel: ObservableObject {

    @Published public var stations: [Station]
    @Published public var location: CLLocation?

    public let stationsClient: StationsClient
    public let locationClient: LocationClient

    private var cancellables = Set<AnyCancellable>()

    public init(stations: [Station] = [],
                stationsClient: StationsClient = .live,
                locationClient: LocationClient = .live) {

        self.stations = stations
        self.stationsClient = stationsClient
        self.locationClient = locationClient

        let stationResults: AnyPublisher<[Station], Never> = stationsClient.results
            //TODO: handle errors properly
            .handleEvents(receiveOutput: { print("stationResults", $0.count) })
            .replaceError(with: [])
            .eraseToAnyPublisher()

        self.stationsClient.updateStations()

        locationClient.delegate
            .compactMap { delegateEvent -> CLLocation? in
                print("delegateEvent", delegateEvent)
                switch delegateEvent {
                case .didChangeAuthorization(let status):
                    print("didChangeAuthorization", status.description)
                case .didUpdateLocations(_):
                    print("did update location")
                case .didFailWithError(_):
                    print("did fail with error")
                }

                guard case .didUpdateLocations(let locations) = delegateEvent else { return nil }
                return locations.first
            }
            .removeDuplicates()
            .assign(to: \.location, on: self)
            .store(in: &cancellables)

        Publishers.CombineLatest(stationResults, self.$location)
            .map { (stations, currentLocation) -> [Station] in
                print("stations and location", stations.count, currentLocation as Any)
                guard let currentLocation = currentLocation else { return stations }

                return stations
                    .sorted(by: { (lhs, rhs) in
                        return lhs.coordinate.distance(from: currentLocation) <
                            rhs.coordinate.distance(from: currentLocation)
                    })
            }
            .assign(to: \.stations, on: self)
            .store(in: &cancellables)

        locationClient.delegate
            .sink(receiveValue: { event in
                switch event {
                case let .didChangeAuthorization(status):
                    self.handle(status)
                case .didUpdateLocations(_):
                    break
                case .didFailWithError:
                    //TODO: handle error
                    break
                }
            })
            .store(in: &cancellables)

    }

    func handle(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            self.locationClient.requestWhenInUseAuthorization()
        case .restricted, .denied:
            // TODO: show an alert
            self.location = nil
            break
        case .authorizedWhenInUse:
            self.locationClient.requestLocation()
        case .authorizedAlways:
            print("This shouldn't happen because we never request .authorizedAlways")
            self.location = nil
        @unknown default:
            break
        }

    }
}
