import Combine
import SwiftUI
import LocationClient

public struct StationsListView: View {
    @ObservedObject var viewModel: StationsViewModel
    
    public var body: some View {
        ScrollView {
            if viewModel.stations.isEmpty {
                ProgressView()
            } else {
                LazyVStack {
                    ForEach(viewModel.stations, id: \.self) { station in
                        NavigationLink(destination: StationsMapView(region: station.coordinate.region(), stations: viewModel.stations)) {
                            StationCardView(station: station, location: viewModel.location)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .navigationTitle("Mo'Bikes")
        .toolbar {
            HStack {
                NavigationLink(destination: MoreView()) {
                    Image(systemName: "ellipsis.circle")
                }
                NavigationLink(destination: StationsMapView(region: {
                    if let location = viewModel.location {
                        return location.coordinate.region()
                    } else {
                        return Coordinates.cityHall.region()
                    }
                }(),
                stations: viewModel.stations)) {
                    Image(systemName: "location")
                }
            }
            
        }
        .accentColor(Color.Mo.primary)
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
        NavigationView {
        StationsListView(viewModel: .init(locationClient: .live))
            .preferredColorScheme(.dark)
        
        //            .previewDevice("Apple Watch Series 6 - 40mm")
        //            .previewLayout(PreviewLayout.fixed(width: 300, height: 600))
        }
        
    }
}
