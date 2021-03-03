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


