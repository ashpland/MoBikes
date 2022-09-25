import MapKit
import SwiftUI
import UIKit

final class StationMarkerAnnotationView: MKAnnotationView {
    static let identifier = "\(StationMarkerAnnotationView.self)"
    
    private let hostingController = UIHostingController<StationMarker>(rootView: StationMarker(station: .blank))

    override var annotation: MKAnnotation? {
        willSet { update(annotation: newValue) }
    }
    
    private func update(annotation: MKAnnotation?) {
        guard let stationAnnotation = annotation as? StationAnnotation else { return }
        let stationMarker = StationMarker(station: stationAnnotation.station)
        self.hostingController.rootView = stationMarker
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.addSubview(hostingController.view)
        self.update(annotation: annotation)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
