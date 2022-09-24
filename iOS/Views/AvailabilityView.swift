import SwiftUI
import UIKit
import MapKit

final class AvailabilityAnnotationView: MKAnnotationView {
    
    static let identifier = "\(AvailabilityAnnotationView.self)"
    
    private var arc: CAShapeLayer?
    
    override var annotation: MKAnnotation? {
        willSet { update(annotation: newValue) }
    }
    
    private func update(annotation: MKAnnotation?) {
        if let arc = arc {
            arc.removeFromSuperlayer()
        }
        
        if let stationMarker = annotation as? StationMarker {
            let percent = availabilityPercent(stationMarker.station)
            let arc = drawPercentArc(percent, color: tintColor.cgColor, 
                                     frame: self.frame, bounds: self.bounds)
            self.layer.addSublayer(arc)
            self.arc = arc
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.layer.borderColor = UIColor.systemBackground.cgColor
        if let annotation = self.annotation {
            self.update(annotation: annotation)
        }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        let width = 40.0
        self.frame = CGRect(x: 0, y: 0, 
                            width: width, 
                            height: width)
        self.layer.cornerRadius = width / 2
        self.backgroundColor = .systemBackground
        self.addSubview(makeBikeView(in: self.frame, color: tintColor))
        self.update(annotation: annotation)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

func availabilityPercent(_ station: Station) -> CGFloat {
    CGFloat(station.available.bikes) / CGFloat(station.available.total)
}

func percentToRadians(_ percent: CGFloat) -> CGFloat {
    let startAngle = (3 * CGFloat.pi / 2)
    return startAngle + ((1 - percent) * (2 * CGFloat.pi))
}

func drawPercentArc(_ percent: CGFloat, color: CGColor, frame: CGRect, bounds: CGRect) -> CAShapeLayer {
    let path = UIBezierPath(arcCenter: .init(x: frame.width, 
                                             y: frame.height), 
                            radius: frame.height * 0.44, 
                            startAngle: percentToRadians(0), 
                            endAngle: percentToRadians(percent), 
                            clockwise: false)
    let ring = CAShapeLayer()
    ring.strokeColor = color
    ring.fillColor = UIColor.clear.cgColor
    ring.lineWidth = frame.width / 10
    ring.path = path.cgPath
    ring.bounds = bounds
    return ring
}

func makeBikeView(in frame: CGRect, color: UIColor) -> UIImageView {
    let bikeInset = frame.width / 4
//    let bikeImage = UIImage(named: "bikeIcon")?
    let bikeImage = UIImage(systemName: "bicycle")?
        .withTintColor(color, renderingMode: .alwaysOriginal)
    let bikeView = UIImageView(image: bikeImage)
    bikeView.frame = CGRect(x: bikeInset / 2, 
                            y: (bikeInset / 2) - 1, 
                            width: frame.width - bikeInset, 
                            height: frame.height - bikeInset)
    bikeView.contentMode = .scaleAspectFit
    return bikeView
}
