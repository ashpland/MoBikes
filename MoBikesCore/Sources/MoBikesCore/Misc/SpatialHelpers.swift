import MapKit

enum CoordinateOrder {
    public static let latFirst = (lat: 0, lng: 1)
    public static let lngFirst = (lat: 1, lng: 0)
}

func convertRawCoordinates(_ raw: String, _ order: (lat: Int, lng: Int)) -> CLLocationCoordinate2D {
    let components = raw
        .replacingOccurrences(of: " ", with: "")
        .components(separatedBy: ",")
    guard let lat = Double(components[order.lat]),
          let lng = Double(components[order.lng]) else { return kCLLocationCoordinate2DInvalid }
    return CLLocationCoordinate2D(latitude: lat, longitude: lng)
}

extension CLLocationDistance {
    public func asUnitString() -> String {
        let distanceInMeters = Measurement(value: self.rounded(), unit: UnitLength.meters)
        let formatter = MeasurementFormatter()
        formatter.locale = Locale(identifier: "en_CA")
        formatter.unitOptions = .naturalScale
        formatter.numberFormatter.maximumFractionDigits = 1
        return formatter.string(from: distanceInMeters)
    }
}

extension CLLocation {
    convenience init(_ coordinates: CLLocationCoordinate2D) {
        self.init(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
}

extension CLLocationCoordinate2D: Equatable, Hashable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude &&
            lhs.longitude == rhs.longitude
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }

}

extension CLLocationCoordinate2D {
    public var location: CLLocation {
        return CLLocation(self)
    }

    public func distance(from location: CLLocation) -> CLLocationDistance {
        self.location.distance(from: location)
    }

    public func region(spanning delta: CLLocationDegrees = 0.006) -> MKCoordinateRegion {
        MKCoordinateRegion(center: self,
                           span: .init(latitudeDelta: delta, longitudeDelta: delta))
    }
}

public enum Coordinates {

    public static let cityHall   = CLLocationCoordinate2D(latitude: 49.260919069539746,
                                              longitude: -123.11397548064534)
    public static let lostLagoon = CLLocationCoordinate2D(latitude: 49.29438528642601,
                                              longitude: -123.13785887586177)

    public static func randomVancouver() -> CLLocationCoordinate2D {
        let latMax =   49.321689
        let latMin =   49.181413
        let lngMax = -122.994335
        let lngMin = -123.237431

        return CLLocationCoordinate2DMake(Double.random(in: latMin...latMax),
                                          Double.random(in: lngMin...lngMax))
    }
}
