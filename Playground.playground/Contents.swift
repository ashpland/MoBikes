import MapKit
import PlaygroundSupport
import MoBikesCore

let rawDistance = 1234.432438
let distanceInMeters = Measurement(value: round(rawDistance), unit: UnitLength.meters)
let formatter = MeasurementFormatter()
formatter.locale = Locale(identifier: "en_CA")
formatter.unitOptions = .naturalScale
formatter.numberFormatter.maximumFractionDigits = 2
formatter.string(from: distanceInMeters)

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

