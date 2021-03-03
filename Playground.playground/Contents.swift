import MapKit
import PlaygroundSupport
import MoBikesCore
import SwiftUI
import Combine
import LocationClient

func after(_ delaySeconds: Double, _ closure: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delaySeconds) {
        closure()
    }
}

var cancellables = Set<AnyCancellable>()

//// Now let's create a MKMapView
//let mapView = MKMapView(frame: CGRect(x:0, y:0, width:500, height:500))
//
//// Define a region for our map view
//var mapRegion = MKCoordinateRegion()
//
//let mapRegionSpan = 0.3
//mapRegion.center = Current.location().coordinate
//mapRegion.span.latitudeDelta = mapRegionSpan
//mapRegion.span.longitudeDelta = mapRegionSpan
//
//mapView.setRegion(mapRegion, animated: true)
//mapView.showsUserLocation = true
//

//
//func randomVancouverCoordinate() -> CLLocationCoordinate2D {
//    let latMax =   49.321689
//    let latMin =   49.181413
//    let lngMax = -122.994335
//    let lngMin = -123.237431
//
//    return CLLocationCoordinate2DMake(Double.random(in: latMin...latMax),
//                                      Double.random(in: lngMin...lngMax))
//}
//
//class RandomMark: NSObject, MKAnnotation {
//    var coordinate: CLLocationCoordinate2D
//    var title: String? = nil
//
//    override init() {
//        self.coordinate = randomVancouverCoordinate()
//        super.init()
//    }
//}
//
//for i in 1...100 {
//    after(Double(i)/20) {
//        mapView.addAnnotation(RandomMark())
//    }
//}

//PlaygroundPage.current.setLiveView(mapView)



    let stationsClient: StationsClient = {
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
    
   let nearLocationClient: LocationClient = {
        let locationDelegateSubject = PassthroughSubject<LocationClient.DelegateEvent, Never>()
        
        return .init(authorizationStatus: { .authorizedAlways },
                     requestWhenInUseAuthorization: { },
                     requestLocation: { locationDelegateSubject.send(.didUpdateLocations([LocationClient.sampleNear])) },
                     delegate: locationDelegateSubject
                        .handleEvents(receiveOutput: { print("output", $0) })
                        .eraseToAnyPublisher())
    }()


let vm: StationsViewModel = .init(stationsClient: .mock,
                                  locationClient: nearLocationClient)


vm.$stations
    .sink(receiveValue: { print("the stations", $0) })
    .store(in: &cancellables)
