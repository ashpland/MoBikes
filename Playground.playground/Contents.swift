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

//
//testImage
//testImage2
//
//Image("bikeIcon")
//
//Current.smooveAPI.getStations = { $0(.failure(SimpleError("yo"))) }

let liveView = StationsView().frame(width: 272, height: 340, alignment: .center)

PlaygroundPage.current.setLiveView(liveView)

Current.smooveAPI.getStations { result in
    guard case let .failure(error) = result else { return }
    error.localizedDescription
}
