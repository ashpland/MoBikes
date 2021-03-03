import Combine
import SwiftUI
import LocationClient

public struct StationsView: View {
    @ObservedObject var vm: StationsViewModel
    
    public var body: some View {
        NavigationView {
            ZStack {
                if vm.stations.isEmpty {
                    ProgressView()
                } else {
                    ScrollView {
                        VStack {
                            ForEach(vm.stations, id: \.self) { station in
                                StationCard(station: station)
                                Divider()
                            }}}}
            }
            .navigationTitle("Mo'Bikes")
            .toolbar {
                Button(action: {
                    vm.locationClient.requestLocation()
                }) {
                    Image(systemName: "arrow.clockwise")
                }
                
            }
        }
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
                     requestLocation: { locationDelegateSubject.send(.didUpdateLocations([nearFar ? LocationClient.sampleNear : LocationClient.sampleFar]))
                        nearFar.toggle()
                     },
                     delegate: locationDelegateSubject.eraseToAnyPublisher())
    }()
    
    static var previews: some View {
        StationsView(vm: .init(stationsClient: .live, locationClient: nearLocationClient))
//            .previewDevice("Apple Watch Series 6 - 40mm")
//            .previewLayout(PreviewLayout.fixed(width: 300, height: 600))
        
    }
}
