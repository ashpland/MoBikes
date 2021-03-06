import Combine
import SwiftUI
import LocationClient

public struct StationsView: View {
    @ObservedObject var viewModel: StationsViewModel

    public var body: some View {
        NavigationView {
            ScrollView {
                ForEach(viewModel.stations, id: \.self) { station in
                    StationCard(station: station, location: viewModel.location)
                }
            }
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
                    }
                }
            }
        }
        .accentColor(Color("MoPurple", bundle: Bundle.module))
    }

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
        var nearFar = false

        return .init(authorizationStatus: { .authorizedAlways },
                     requestWhenInUseAuthorization: { },
                     requestLocation: { locationDelegateSubject.send(.didUpdateLocations([nearFar ? Coordinates.cityHall.location : Coordinates.lostLagoon.location]))
                        nearFar.toggle()
                     },
                     delegate: locationDelegateSubject.eraseToAnyPublisher())
    }()

    static var previews: some View {
        StationsView(viewModel: .init(stationsClient: .mock, locationClient: nearLocationClient))
            .preferredColorScheme(.dark)

//            .previewDevice("Apple Watch Series 6 - 40mm")
//            .previewLayout(PreviewLayout.fixed(width: 300, height: 600))

    }
}
