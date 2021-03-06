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

//let pub: AnyPublisher<LocationClient.DelegateEvent, Never> = Just(LocationClient.DelegateEvent.didUpdateLocations([]))
//    .eraseToAnyPublisher()

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

//let liveStationsClient: StationsClient = .live
//
//liveStationsClient.results
//    .sink(receiveCompletion: { print("recieveCompletion", $0)},
//          receiveValue: { _ in print("recieveValue", Date()) })
//    .store(in: &cancellables)
//
//liveStationsClient.updateStations()
//
//Timer
//    .publish(every: 1, on: .main, in: .common)
//    .autoconnect()
//    .sink(receiveValue: { _ in liveStationsClient.updateStations() })
//    .store(in: &cancellables)

let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
dateFormatter.date(from: "2021-03-06 21:26:14 +0000")
let newResultTimes: [Date] = [
    "2021-03-06 21:26:14 +0000",
    "2021-03-06 21:26:56 +0000",
    "2021-03-06 21:27:02 +0000",
    "2021-03-06 21:27:08 +0000",
    "2021-03-06 21:27:14 +0000",
    "2021-03-06 21:27:20 +0000",
    "2021-03-06 21:27:26 +0000",
    "2021-03-06 21:27:44 +0000",
    "2021-03-06 21:28:08 +0000",
    "2021-03-06 21:28:14 +0000",
    "2021-03-06 21:28:20 +0000",
    "2021-03-06 21:28:26 +0000",
    "2021-03-06 21:28:44 +0000",
    "2021-03-06 21:28:56 +0000",
    "2021-03-06 21:29:26 +0000",
    "2021-03-06 21:29:50 +0000",
    "2021-03-06 21:29:56 +0000",
    "2021-03-06 21:30:08 +0000",
    "2021-03-06 21:30:32 +0000",
    "2021-03-06 21:30:56 +0000",
    "2021-03-06 21:31:08 +0000",
    "2021-03-06 21:31:20 +0000",
    "2021-03-06 21:31:26 +0000",
    "2021-03-06 21:31:32 +0000",
    "2021-03-06 21:31:38 +0000",
    "2021-03-06 21:32:02 +0000"]
    .compactMap { dateFormatter.date(from: $0) }


let pairs = zip(newResultTimes, newResultTimes.dropFirst())
let diffs = pairs.map { (lhs, rhs) -> TimeInterval in
    lhs.distance(to: rhs)
}

Set(diffs).sorted()
