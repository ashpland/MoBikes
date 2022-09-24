import MapKit

class MapViewCoordinator: NSObject, MKMapViewDelegate {
    let action: (StateManager.Action) -> Void
    
    init(action: @escaping (StateManager.Action) -> Void) {
        self.action = action
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        action(.updateRegion(mapView.region))
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        makeRenderer(overlay)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        mapView.dequeueReusableAnnotationView(withIdentifier: AvailabilityAnnotationView.identifier, for: annotation)
    }
}

func makeRenderer(_ overlay: MKOverlay) -> MKOverlayRenderer {
    let bikeway = overlay as? Bikeway
    let renderer = MKMultiPolylineRenderer(overlay: overlay)
    |> assoc(\.strokeColor, .systemGreen)
    >>> assoc(\.lineWidth, 3)
    >>> assoc(\.alpha, 0.7)
    >>> assoc(\.lineCap, .butt)

    switch bikeway?.category {
    case .shared, .painted:
        return renderer
        |> assoc(\.lineDashPattern, [3, 3])
        >>> assoc(\.lineCap, .butt)
    default:
        return renderer
    }
}
