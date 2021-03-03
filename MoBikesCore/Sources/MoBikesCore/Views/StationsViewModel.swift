import Combine
import CoreLocation
import Foundation
import LocationClient

final class StationsViewModel: ObservableObject {
    
    @Published var stations: [Station] = []
    
    let stationsClient: StationsClient
    let locationClient: LocationClient
    
    private var stationRequestCancelable: AnyCancellable?
    
    init(stationsClient: StationsClient = .live, locationClient: LocationClient = .live) {
        self.stationsClient = stationsClient
        self.locationClient = locationClient
        self.stationRequestCancelable = stationsClient.results
            // handle errors properly
            .replaceError(with: [])
            .map { stations in
                stations
                    .filter { $0.operative }
                    .sorted(by: { (lhs, rhs) in
                        let near = CLLocation(latitude: 49.26307047497602, longitude: -123.11455871130153)
                        return lhs.location.distance(from: near) < rhs.location.distance(from: near)
                        
                    })
            }
            .assign(to: \.stations, on: self)
    }
}
