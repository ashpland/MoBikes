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
