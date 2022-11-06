import Combine
import MapKit
import SwiftUI

// https://medium.com/flawless-app-stories/mapkit-in-swiftui-c0cc2b07c28a
struct MapView: UIViewRepresentable {
    @EnvironmentObject var sm: StateManager<iosState>
    
    func makeCoordinator() -> MapViewCoordinator{
        MapViewCoordinator(dispatch: sm.dispatchAsync)
    }
    
    func makeUIView(context: Context) -> MKMapView{
        MKMapView(frame: .zero)
        |>  registerAnnotationView(view: StationMarkerAnnotationView.self)
        >>> configureMinimalMap
        >>> setRegion(sm.db.region.mkCoordinateRegion)
        >>> addCoordinator(context.coordinator)
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        let shouldFreezeMap = sm.db.ui.freezeMap
        if shouldFreezeMap {
            sm.dispatchAsync(.platform(.updateUIBool(.init(kp: \.freezeMap, value: false))))
        }
        _ = view
        |>  updateRegion(sm.db.region, shouldFreezeMap)
        >>> updateBikeways(view.overlays, sm.db.bikeways, sm.db.ui.mapSettings.showBikeways)
        >>> updateStations(view.annotations, sm.db.stations, sm.db.ui.mapSettings.showStations)
    }
}

// Make View
let configureMinimalMap: (MKMapView) -> MKMapView = 
assoc(\.mapType, .mutedStandard)
>>> assoc(\.pointOfInterestFilter, .excludingAll)
>>> assoc(\.showsScale, false)
>>> assoc(\.showsBuildings, false)
>>> assoc(\.isPitchEnabled, false)
>>> assoc(\.showsUserLocation, true)

let setRegion = flip2ArgVoid(MKMapView.setRegion)(false)
let addCoordinator = curry(assoc)(\MKMapView.delegate)

// Update View
func updateRegion(_ newRegion: Region, _ shouldFreezeMap: Bool) -> (MKMapView) -> MKMapView {
    return { mapView in
        if let coordinator = mapView.delegate as? MapViewCoordinator,
           let currentRegion = Region(mapView.region) {
            let shouldNewRegionBeSet = (shouldFreezeMap || coordinator.isChanging == false) && (newRegion != currentRegion)
            
            if shouldNewRegionBeSet {
                mapView.setRegion(newRegion.mkCoordinateRegion, animated: true)
            }
        }
        return mapView
    }
}

func updateBikeways(_ overlays: [MKOverlay], _ bikeways: [Bikeway], _ showBikeways: Bool) -> (MKMapView) -> MKMapView {
    switch (showBikeways, overlays.count) {
    case (true, 0):
        return addOverlaysAboveRoads(bikeways)
    case (false, 1...):
        return removeOverlays(bikeways)
    default:
        return identity
    }
}

func updateStations(_ annotations: [MKAnnotation], _ stations: [Station], _ showStations: Bool) -> (MKMapView) -> MKMapView {
    let currentMarkers = annotations.compactMap { $0 as? StationAnnotation }
    switch (showStations, currentMarkers.count) {
    case (true, _):
        if currentMarkers.hashOfStationIds == stations.hashOfIds {
            return identity
        } else {
            let (markersToRemove, stationsToAdd) = getUnique(
                currentMarkers, withID: ^\.station.id,
                and: stations, withID: ^\.id)
            return removeAnnotations(markersToRemove)
            >>> addAnnotations(stationsToAdd.asMarkers)
        }
    case (false, 1...):
        return removeAnnotations(currentMarkers)
    default:
        return identity
    }
}


// Helpers
let addAnnotations = flip(MKMapView.addAnnotations)
let removeAnnotations = flip(MKMapView.removeAnnotations)
let addOverlaysAboveRoads = flip2ArgVoid(MKMapView.addOverlays)(.aboveRoads)
let removeOverlays = flip(MKMapView.removeOverlays)


// ReuseIdentifiable
func registerAnnotationView(view: ReuseIdentifiable.Type) -> (MKMapView) -> MKMapView {
    return { mapView in
        mapView.register(view, forAnnotationViewWithReuseIdentifier: view.identifier)
        return mapView
    }
}

protocol ReuseIdentifiable: MKAnnotationView {
    static var identifier: String { get }
}
extension ReuseIdentifiable {
    static var identifier: String {
        "\(Self.self)"
    }
}
