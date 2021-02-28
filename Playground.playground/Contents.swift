import MapKit
import PlaygroundSupport
import MoBikesCore

// Now let's create a MKMapView
let mapView = MKMapView(frame: CGRect(x:0, y:0, width:300, height:300))

// Define a region for our map view
var mapRegion = MKCoordinateRegion()

let mapRegionSpan = 0.007
mapRegion.center = Current.location().coordinate
mapRegion.span.latitudeDelta = mapRegionSpan
mapRegion.span.longitudeDelta = mapRegionSpan

mapView.setRegion(mapRegion, animated: true)
mapView.showsUserLocation = true

// Add the created mapView to our Playground Live View
PlaygroundPage.current.liveView = mapView

Current.stations { result in
    if case .success(let stations) = result {
        DispatchQueue.main.async {
            let annotations = stations
                .filter { $0.operative }
                .map { station -> Station in
                    station.title = "\(station.location.distance(from: Current.location()).asUnitString())"
                    return station
                }
            
            
            mapView.addAnnotations(annotations)
        }
    }
}

