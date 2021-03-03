import MapKit
import PlaygroundSupport
import MoBikesCore
import SwiftUI
import Combine

// Now let's create a MKMapView
let mapView = MKMapView(frame: CGRect(x:0, y:0, width:500, height:500))

// Define a region for our map view
var mapRegion = MKCoordinateRegion()

let mapRegionSpan = 0.3
mapRegion.center = Current.location().coordinate
mapRegion.span.latitudeDelta = mapRegionSpan
mapRegion.span.longitudeDelta = mapRegionSpan

mapView.setRegion(mapRegion, animated: true)
mapView.showsUserLocation = true

func after(_ delaySeconds: Double, _ closure: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delaySeconds) {
        closure()
    }
}

func randomVancouverCoordinate() -> CLLocationCoordinate2D {
    let latMax =   49.321689
    let latMin =   49.181413
    let lngMax = -122.994335
    let lngMin = -123.237431
    
    return CLLocationCoordinate2DMake(Double.random(in: latMin...latMax),
                                      Double.random(in: lngMin...lngMax))
}

class RandomMark: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String? = nil
    
    override init() {
        self.coordinate = randomVancouverCoordinate()
        super.init()
    }
    
}

for i in 1...100 {
    after(Double(i)/20) {
        mapView.addAnnotation(RandomMark())
    }
}

//PlaygroundPage.current.setLiveView(mapView)

//
//testImage
//testImage2
//
//Image("bikeIcon")
//
//Current.smooveAPI.getStations = { $0(.failure(SimpleError("yo"))) }

//let liveView = StationsView().frame(width: 272, height: 340, alignment: .center)
//
//PlaygroundPage.current.setLiveView(liveView)

//Current.smooveAPI.getStations { result in
//    guard case let .failure(error) = result else { return }
//    error.localizedDescription
//}



//
//
//[1, 2, 3, 4, 5][...2]
//

//
//
var cancellables = Set<AnyCancellable>()

let apiURL = URL(string: "https://vancouver-ca.smoove.pro/api-public/stations")!
//
//let dataTask: AnyPublisher<[Station], Error> = URLSession.shared
//    .dataTaskPublisher(for: apiURL)
//    .map { data, _ in data }
//    .decode(type: Station.Group.self, decoder: JSONDecoder())
//    .map(\.stations)
//    .handleEvents(receiveSubscription: { _ in print("subscribed") },
//                  receiveOutput: { out in print("output", out.first) },
//                  receiveCompletion: { _ in print("completion") },
//                  receiveCancel: { print("cancel") },
//                  receiveRequest: { _ in print("request") })
//
//    .receive(on: DispatchQueue.main)
//    .share()
//    .eraseToAnyPublisher()
//
let requestStations = CurrentValueSubject<Void, Never>(())
let requestResults: AnyPublisher<[Station], Error> = requestStations
    .handleEvents(receiveOutput: { _ in print("request network call") })
    .throttle(for: 6, scheduler: DispatchQueue.main, latest: true)
    .handleEvents(receiveOutput: { _ in print("📞 network call") })
    .flatMap { URLSession.shared.dataTaskPublisher(for: apiURL) }
    .map { data, _ in data }
    .decode(type: Station.Group.self, decoder: JSONDecoder())
    .map(\.stations)
//    .replaceError(with: [])
    .removeDuplicates()
    .receive(on: DispatchQueue.main)
    .eraseToAnyPublisher()

//requestResults.sink(receiveValue: { print($0) }).store(in: &cancellables)

struct StationClient {
    var updateStations: () -> Void
    var results: AnyPublisher<[Station], Error>
}

extension StationClient {
    static var live: StationClient {
        let requestStations = CurrentValueSubject<Void, Never>(())
        return Self.init(
            updateStations: { requestStations.send(()) },
            results: requestStations
                .throttle(for: 6, scheduler: DispatchQueue.main, latest: true)
                .flatMap { URLSession.shared.dataTaskPublisher(for: apiURL) }
                .map { data, _ in data }
                .decode(type: Station.Group.self, decoder: JSONDecoder())
                .map(\.stations)
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        )
    }
}

extension StationClient {
    static var sampleStations: StationClient {
        let requestStations = CurrentValueSubject<Void, Never>(())
        return Self.init(
            updateStations: { requestStations.send(()) },
            results: requestStations
                .flatMap { Just(Station.examples) }
                .receive(on: DispatchQueue.main)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        )
    }
}


//
//
//class StationHolder {
//    @Published var stations: [Station] = [] {
//        didSet {
//            print("didSet", stations[...3].map(\.name))
//        }
//    }
//
//    let sampleInput: CurrentValueSubject<String, Never>
//    let sampleOutput: AnyPublisher<String, Never>
//
//    init() {
//        self.sampleInput = CurrentValueSubject("Initial Value")
//        self.sampleOutput = self.sampleInput.removeDuplicates().eraseToAnyPublisher()
//    }
//}
//
//let stationHolder = StationHolder()
//
////requestResults
////    .removeDuplicates()
////    .assign(to: \.stations, on: stationHolder)
////    .store(in: &cancellables)
//
////
////stationHolder.sampleOutput.sink(receiveValue: { print($0) }).store(in: &cancellables)
////
////after(1) { stationHolder.sampleInput.send("hello there") }
////after(2) { stationHolder.sampleInput.send("hello there") }
////after(3) { stationHolder.sampleInput.send("hello there") }
//
//
//
//
//
//
//func getNewData() {
//    requestStations.send(())
//}
//
//getNewData()
//
//Timer.publish(every: 1, on: .main, in: .default)
//    .autoconnect()
//    .sink(receiveValue: { _ in
//            getNewData() })
//    .store(in: &cancellables)
//
//DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
//    getNewData()
//}
