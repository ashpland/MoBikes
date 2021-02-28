import MapKit
import PlaygroundSupport
import MoBikesCore

func testPretty(input: Double) -> String {
//    String(format: "%.2f", myDouble)
    if (input < 1000) {
        return String(format: "%.0f", input) + " m"
    } else {
        return String(format: "%.2f", input / 1000) + " km"
    }
}

testPretty(input: 343.234290835)


let center = CLLocationCoordinate2DMake(49.262487, -123.114397)

// Now let's create a MKMapView
let mapView = MKMapView(frame: CGRect(x:0, y:0, width:300, height:300))

// Define a region for our map view
var mapRegion = MKCoordinateRegion()

let mapRegionSpan = 0.07
mapRegion.center = center
mapRegion.span.latitudeDelta = mapRegionSpan
mapRegion.span.longitudeDelta = mapRegionSpan

mapView.setRegion(mapRegion, animated: true)

// Add the created mapView to our Playground Live View
PlaygroundPage.current.liveView = mapView

Current.stations { result in
    if case .success(let stations) = result {
        DispatchQueue.main.async {
            mapView.addAnnotations(stations.filter { $0.operative })
        }
    }
}

