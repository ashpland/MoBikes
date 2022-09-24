import Combine
import MapKit
import SwiftUI

// https://medium.com/flawless-app-stories/mapkit-in-swiftui-c0cc2b07c28a
struct MapView: UIViewRepresentable {
    @EnvironmentObject var sm: StateManager
    
    func makeCoordinator() -> MapViewCoordinator{
        MapViewCoordinator(action: sm.action)
    }
    
    func makeUIView(context: Context) -> MKMapView{
        sm.action(.loadBikeways)
        sm.action(.updateStations)
        let mapView = MKMapView(frame: .zero)
        
        mapView.register(AvailabilityAnnotationView.self, forAnnotationViewWithReuseIdentifier: AvailabilityAnnotationView.identifier)
        
        return mapView 
        |> configureMinimalMap 
        <> setRegion(sm.state.region.mkCoordinateRegion)
        <> addCoordinator(context.coordinator)
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        _ = view 
        |> updateRegion(sm.state.region)
        <> updateBikeways(view.overlays, sm.state.bikeways)
        <> updateStations(view.annotations, sm.state.stations)
    }
}

// Make View
let configureMinimalMap: (MKMapView) -> MKMapView = 
assoc(\.mapType, .mutedStandard)
<> assoc(\.pointOfInterestFilter, .excludingAll)
<> assoc(\.showsScale, false)
<> assoc(\.showsBuildings, false)
<> assoc(\.isPitchEnabled, false)

let setRegion = flip2ArgVoid(MKMapView.setRegion)(false)
let addCoordinator = curry(assoc)(\MKMapView.delegate)

// Update View
func updateRegion(_ newRegion: Region) -> (MKMapView) -> MKMapView {
    return { mapView in
        if let currentRegion = Region(mapView.region),
           newRegion != currentRegion {
            mapView.setRegion(newRegion.mkCoordinateRegion, animated: true)
        }
        return mapView
    }
}

func updateBikeways(_ overlays: [MKOverlay], _ bikeways: [Bikeway]) -> (MKMapView) -> MKMapView {
    overlays.count > 0 ? identity : addOverlaysAboveRoads(bikeways)
}

func updateStations(_ annotations: [MKAnnotation], _ stations: [Station]) -> (MKMapView) -> MKMapView {
    let currentMarkers = annotations.compactMap { $0 as? StationMarker }
    if currentMarkers.hashOfStationIds == stations.hashOfIds {
        return identity
    } else {
        let (markersToRemove, stationsToAdd) = getUnique(
            currentMarkers, withID: ^\.station.id, 
            and: stations, withID: ^\.id)
        return removeAnnotations(markersToRemove) 
        <> addAnnotations(stationsToAdd.asMarkers)
    }
}

// Helpers
let addAnnotations = flip(MKMapView.addAnnotations)
let removeAnnotations = flip(MKMapView.removeAnnotations)
let addOverlaysAboveRoads = flip2ArgVoid(MKMapView.addOverlays)(.aboveRoads)
