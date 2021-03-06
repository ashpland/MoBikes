import Combine
import CoreLocation
import Foundation
import LocationClient

public final class StationsViewModel: ObservableObject {

    @Published public var stations: [Station] = []
    @Published public var location: CLLocation = Coordinates.cityHall.location

    public let stationsClient: StationsClient
    public let locationClient: LocationClient

    private var stationRequestCancelable: AnyCancellable?
    private var locationDelegateCancellable: AnyCancellable?
    private var currentLocationCancellable: AnyCancellable?

    public init(stationsClient: StationsClient = .live, locationClient: LocationClient = .live) {
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
                        return lhs.coordinates.distance(from: currentLocation) <
                            rhs.coordinates.distance(from: currentLocation)
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
    
    private func handleDelegateEvent(_ event: LocationClient.DelegateEvent) -> Void {
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
