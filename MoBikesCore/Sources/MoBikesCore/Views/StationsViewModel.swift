import Combine
import CoreLocation
import Foundation
import LocationClient

public final class StationsViewModel: ObservableObject {
    
    @Published public var stations: [Station] = []
    @Published public var location: CLLocation = Location.cityHall
    
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

        self.currentLocationCancellable = locationClient.delegate
            .compactMap { delegateEvent -> CLLocation? in
                if case .didUpdateLocations(let locations) = delegateEvent,
                   let location = locations.first {
                    return location
                } else {
                    return nil
                }
            }
            .removeDuplicates()
            .assign(to: \.location, on: self)
        
        self.stationRequestCancelable = Publishers.CombineLatest(stationResults, self.$location)
            .map { (stations, currentLocation) -> [Station] in
                stations
                    .filter { $0.operative }
                    .sorted(by: { (lhs, rhs) in
                        return lhs.location.distance(from: currentLocation) <
                            rhs.location.distance(from: currentLocation)
                    })
            }
            .assign(to: \.stations, on: self)
        
        self.locationDelegateCancellable = self.locationClient.delegate
            .handleEvents(receiveOutput: { print("output", $0) })
          .sink { event in
            switch event {
            case let .didChangeAuthorization(status):
              switch status {
              case .notDetermined:
                break
              case .restricted:
                // TODO: show an alert
                break
              case .denied:
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
        
        switch self.locationClient.authorizationStatus() {
        case .notDetermined:
            self.locationClient.requestWhenInUseAuthorization()
        case .restricted:
            // TODO: show an alert
            break
        case .denied:
            // TODO: show an alert
            break
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationClient.requestLocation()
        @unknown default:
            break
        }
    }
}
