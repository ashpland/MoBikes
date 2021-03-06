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

let pub: AnyPublisher<LocationClient.DelegateEvent, Never> = Just(LocationClient.DelegateEvent.didUpdateLocations([]))
    .eraseToAnyPublisher()

//pub.filter

//extension Publisher {
//
//    public func filter(_ isIncluded: @escaping (Self.Output) -> Bool) -> Publishers.Filter<Self>
//
//}

//    .compactMap { delegateEvent -> CLLocation? in
//        if case .didUpdateLocations(let locations) = delegateEvent,
//           let location = locations.first {
//            return location
//        } else {
//            return nil
//        }
//    }
//    .removeDuplicates()

//let event = LocationClient.DelegateEvent.didUpdateLocations([])
//
////let test: [CLLocation]? = case let .didUpdateLocations(locations) = delegateEvent
//
//if case .didUpdateLocations(let locations) = event {
//    print(locations)
//}
//
//let temp = pub
//    .compactMap { event -> CLAuthorizationStatus? in
//        guard case .didChangeAuthorization(let status) = event else { return nil }
//        return status
//    }

//let stationsClient: StationsClient = {
//    let submitStations = CurrentValueSubject<[Station], Never>([])
//    var flip = true
//    return .init(updateStations: {
//        submitStations.send(flip ? Station.examples : [])
//        flip.toggle()
//    },
//    results: submitStations
//        .setFailureType(to: Error.self)
//        .eraseToAnyPublisher())
//}()

let nearLocationClient: LocationClient = {
    let locationDelegateSubject = PassthroughSubject<LocationClient.DelegateEvent, Never>()
    var nearFar = false

    return .init(authorizationStatus: { .authorizedAlways },
                 requestWhenInUseAuthorization: { },
                 requestLocation: { locationDelegateSubject.send(.didUpdateLocations([nearFar ? Coordinates.cityHall.location : Coordinates.lostLagoon.location]))
                    nearFar.toggle()
                 },
                 delegate: locationDelegateSubject.eraseToAnyPublisher())
}()

//let liveView = StationsListView(viewModel: .init(stationsClient: .live, locationClient: nearLocationClient))

//PlaygroundPage.current.setLiveView(liveView)

let locationClient: LocationClient = .live

locationClient.delegate.sink(receiveValue: { event in
    switch event {
    case .didChangeAuthorization(let status):
        print("didChangeAuthorization")
        switch status {
        case .notDetermined:
            print("notDetermined")
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
        case .authorizedAlways:
            print("authorizedAlways")
        case .authorizedWhenInUse:
            print("authorizedWhenInuse")
        @unknown default:
            print("unknown")
        }
    case .didUpdateLocations(_):
        print("did update location")
    case .didFailWithError(_):
        print("did fail with error")
    }
})
.store(in: &cancellables)

let viewModel: StationsViewModel = .init(locationClient: locationClient)

extension Publisher {
    func sinkPrint() -> AnyCancellable {
        self.sink(receiveCompletion: { Swift.print("recieveCompletion", $0) },
                  receiveValue: { Swift.print("recieveValue", $0) })
    }
}

viewModel.$stations.map { $0.count }.sinkPrint().store(in: &cancellables)
