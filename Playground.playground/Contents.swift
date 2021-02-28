import MapKit
import PlaygroundSupport
import MoBikesCore
import SwiftUI
import Combine

//// Now let's create a MKMapView
//let mapView = MKMapView(frame: CGRect(x:0, y:0, width:300, height:300))
//
//// Define a region for our map view
//var mapRegion = MKCoordinateRegion()
//
//let mapRegionSpan = 0.007
//mapRegion.center = Current.location().coordinate
//mapRegion.span.latitudeDelta = mapRegionSpan
//mapRegion.span.longitudeDelta = mapRegionSpan
//
//mapView.setRegion(mapRegion, animated: true)
//mapView.showsUserLocation = true
//

//// Add the created mapView to our Playground Live View
//PlaygroundPage.current.liveView = mapView
//
//Current.stations { result in
//    if case .success(let stations) = result {
//        DispatchQueue.main.async {
//            let annotations = stations
//                .filter { $0.operative }
//                .map { station -> Station in
//                    station.title = "\(station.location.distance(from: Current.location()).asUnitString())"
//                    return station
//                }
//
//
//            mapView.addAnnotations(annotations)
//        }
//    }
//}

//let liveView = StationCard(station: Station.examples[0])
//DispatchQueue.main.async {
//    PlaygroundPage.current.setLiveView(liveView)
//}

struct StationsView: View {
    @ObservedObject var stationGetter = StationGetter()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(stationGetter.stations, id: \.self, content: StationCard.init)
            }
        }
    }

    func updateStations() {
        Current.stations { result in
            if case .success(let stations) = result {
                let operativeStations = stations
                    .filter { $0.operative }

                if let last = stations.last {
                    print (last.name)
                }
                
                DispatchQueue.main.async {
                    self.stationGetter.stations.append(contentsOf: operativeStations)
                }
            }
        }
    }
    
    final class StationGetter: ObservableObject {
        let objectWillChange = PassthroughSubject<Void, Never>()
        var stations: [Station] = [] {
            willSet {
                objectWillChange.send()
            }
        }
    }
    
}



let liveView = StationsView()
liveView.updateStations()

PlaygroundPage.current.setLiveView(liveView)
