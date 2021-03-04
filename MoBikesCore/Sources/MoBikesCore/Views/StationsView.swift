import Combine
import SwiftUI
import LocationClient

public struct StationsView: View {
    @ObservedObject var viewModel: StationsViewModel

    public var body: some View {
        NavigationView {
            ZStack {
                if viewModel.stations.isEmpty {
                    ProgressView()
                } else {
                    ScrollView {
                        VStack {
                            ForEach(viewModel.stations, id: \.self) { station in
                                StationCard(station: station, location: viewModel.location)
                                Divider()
                            }}}}}
            .navigationTitle("Mo'Bikes")
            .toolbar {
                HStack {
                    Button(action: {
                        viewModel.stationsClient.updateStations()
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                    Button(action: {
                        viewModel.locationClient.requestLocation()
                    }) {
                        Image(systemName: "location")
                    }}}}}

    public init(viewModel: StationsViewModel = StationsViewModel()) {
        self.viewModel = viewModel
    }
}

struct StationsView_Previews: PreviewProvider {
    static let stationsClient: StationsClient = {
        let submitStations = CurrentValueSubject<[Station], Never>([])
        var flip = true
        return .init(updateStations: {
            submitStations.send(flip ? Station.examples : [])
            flip.toggle()
        },
        results: submitStations
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher())
    }()

    static let nearLocationClient: LocationClient = {
        let locationDelegateSubject = PassthroughSubject<LocationClient.DelegateEvent, Never>()
        var nearFar = true

        return .init(authorizationStatus: { .authorizedAlways },
                     requestWhenInUseAuthorization: { },
                     requestLocation: { locationDelegateSubject.send(.didUpdateLocations([nearFar ? Location.cityHall : Location.lostLagoon]))
                        nearFar.toggle()
                     },
                     delegate: locationDelegateSubject.eraseToAnyPublisher())
    }()

    static var previews: some View {
        StationsView(viewModel: .init(stationsClient: stationsClient, locationClient: nearLocationClient))
//            .previewDevice("Apple Watch Series 6 - 40mm")
//            .previewLayout(PreviewLayout.fixed(width: 300, height: 600))

    }
}
