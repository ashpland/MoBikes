import MapKit

class StationAnnotation: NSObject, MKAnnotation {
    let station: Station
    let coordinate: CLLocationCoordinate2D
    var title: String? { station.name }
    var subtitle: String? {
        "\(station.available.bikes) bikes | \(station.available.docks) docks"
    }
    
    init(station: Station) {
        self.station = station
        self.coordinate = station.coordinate.clLocationCoordinate2D
    }
}

extension Array where Element == Station {
    var asMarkers: [StationAnnotation] { self.map(StationAnnotation.init) }
}

extension Array where Element == StationAnnotation {
    var hashOfStationIds: Int {
        self.map(\.station.id).sorted().hashValue
    }
}
