import Combine
import CoreLocation
import Foundation
import LocationClient
import MapKit
import SwiftUI

public final class StationsViewModel: ObservableObject {

    @Published public var stations: [Station]
    @Published public var location: CLLocation
    @State public var region: MKCoordinateRegion

    public let stationsClient: StationsClient
    public let locationClient: LocationClient

    private var stationRequestCancelable: AnyCancellable?
    private var locationDelegateCancellable: AnyCancellable?
    private var currentLocationCancellable: AnyCancellable?

    public init(stations: [Station] = [],
                location: CLLocation = Coordinates.cityHall.location,
                region: MKCoordinateRegion = Coordinates.cityHall.region(),
                stationsClient: StationsClient = .live,
                locationClient: LocationClient = .live) {

        self.stations = stations
        self.location = location
        self.region = region
        self.stationsClient = stationsClient
        self.locationClient = locationClient

        let stationResults: AnyPublisher<[Station], Never> = stationsClient.results
            // handle errors properly
            .replaceError(with: [])
            .eraseToAnyPublisher()

        self.stationsClient.updateStations()

        self.currentLocationCancellable = locationClient.delegate
            .compactMap { delegateEvent -> CLLocation? in
                guard case .didUpdateLocations(let locations) = delegateEvent else { return nil }
                return locations.first
            }
            .removeDuplicates()
            .assign(to: \.location, on: self)

        self.stationRequestCancelable = Publishers.CombineLatest(stationResults, self.$location)
            .map { (stations, currentLocation) -> [Station] in
                stations
                    .sorted(by: { (lhs, rhs) in
                        return lhs.coordinate.distance(from: currentLocation) <
                            rhs.coordinate.distance(from: currentLocation)
                    })
            }
            .assign(to: \.stations, on: self)

        self.locationDelegateCancellable = self.locationClient.delegate
          .sink(receiveValue: handleDelegateEvent)

        switch self.locationClient.authorizationStatus() {
        case .notDetermined:
            self.locationClient.requestWhenInUseAuthorization()
        case .restricted, .denied:
            // TODO: show an alert
            break
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationClient.requestLocation()
        @unknown default:
            break
        }
    }

    private func handleDelegateEvent(_ event: LocationClient.DelegateEvent) {
        switch event {
        case let .didChangeAuthorization(status):
          switch status {
          case .notDetermined:
            self.locationClient.requestWhenInUseAuthorization()
          case .restricted, .denied:
            // TODO: show an alert
            break
          case .authorizedAlways, .authorizedWhenInUse:
            self.locationClient.requestLocation()
          @unknown default:
            break
          }
        case .didUpdateLocations(_):
            break
        case .didFailWithError:
          break
        }
    }
}
