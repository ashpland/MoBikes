import MapKit
import PlaygroundSupport
import MoBikesCore


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


getStations { result in
    switch result {
    case .success(let stations):
        if let last = stations.last {
            print(last.name)
        }
        DispatchQueue.main.async {
            mapView.addAnnotations(stations)
        }
    case .failure(let error):
        print(error.localizedDescription)
    }
}
