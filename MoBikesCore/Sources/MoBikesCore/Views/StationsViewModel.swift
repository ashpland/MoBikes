import Foundation
import Combine

final class StationsViewModel: ObservableObject {
    
    @Published var stations: [Station] = []
    
    let stationsClient: StationsClient
    
    private var stationRequestCancelable: AnyCancellable?
    
    init(stationsClient: StationsClient = .live) {
        self.stationsClient = stationsClient
        self.stationRequestCancelable = stationsClient.results
            // handle errors properly
            .replaceError(with: [])
            .map { $0.filter { $0.operative } }
            .assign(to: \.stations, on: self)
    }
}
