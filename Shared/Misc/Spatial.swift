import MapKit

struct Coordinate: Equatable, Codable {
    let latitude: Degrees<Latitude>
    let longitude: Degrees<Longitude>
}

enum Latitude {
    static let degrees = Degrees<Latitude>.inRange(-90.0...90.0)
}
enum Longitude {
    static let degrees = Degrees<Longitude>.inRange(-180.0...180.0)
}

struct Region: Equatable, Codable {
    let center: Coordinate
    let span: Span
}

struct Span: Equatable, Codable {
    let latitudeDelta: CLLocationDegrees
    let longitudeDelta: CLLocationDegrees
}

// Coordinate Initializers
extension Coordinate {
    init?(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        guard let latitude = Latitude.degrees(latitude),
              let longitude = Longitude.degrees(longitude) else {
                  return nil
              }
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init?(_ coordinate: CLLocationCoordinate2D) {
        self.init(latitude: coordinate.latitude, 
                  longitude: coordinate.longitude)
    }
    
    init?(_ location: CLLocation?) {
        guard let coordinate = location?.coordinate else { return nil }
        self.init(latitude: coordinate.latitude,
                  longitude: coordinate.longitude)
    }
    
    static func parse(_ order: Order) -> (String) -> Coordinate? {
        return { 
            guard let parsedCoordinates = $0 
            |> separateAndTrimWhitespace
            >>> compactMap(CLLocationDegrees.init)
            >>> firstTwo
            >>> flatMap(order.sort)
            else { return nil }
            return parsedCoordinates |> Coordinate.init
        }
    }
}

extension Coordinate {
    enum Order {
        case latitudeFirst
        case longitudeFirst
        
        var sort: (Double, Double) -> (rawLatitude: Double, rawLongitude: Double) {
            switch self {
            case .latitudeFirst: return { ($0, $1) }
            case .longitudeFirst: return { ($1, $0) }
            }
        }
    }
}

struct Degrees<Type>: Equatable, Codable {
    var value: CLLocationDegrees
    
    private init(value: CLLocationDegrees) {
        self.value = value
    }
    
    fileprivate static func inRange(_ range: ClosedRange<CLLocationDegrees>) -> (CLLocationDegrees) -> Degrees<Type>? {
        return { degrees in
            guard range ~= degrees else {
                return nil
            }
            return .init(value: degrees)
        }
    }
}

// MapKit Helpers
extension Coordinate {
    var clLocationCoordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude.value, 
                               longitude: longitude.value)
    }
    
    var clLocation: CLLocation {
        CLLocation(latitude: latitude.value,
                   longitude: longitude.value)
    }
    
    func distanceFrom(_ otherCoordinate: Coordinate) -> CLLocationDistance {
        self.clLocation.distance(from: otherCoordinate.clLocation)
    }
    
    func region(spanning delta: CLLocationDegrees = Constants.startingLongitudeDeltaForMap) -> Region {
        Region(center: self, 
               span: Span(latitudeDelta: delta, 
                          longitudeDelta: delta))
    }
}

extension Span {
    var mkCoordinateSpan: MKCoordinateSpan {
        MKCoordinateSpan(latitudeDelta: self.latitudeDelta, 
                         longitudeDelta: self.longitudeDelta)
    }
    
    init(_ span: MKCoordinateSpan) {
        self.init(latitudeDelta: span.latitudeDelta, 
                  longitudeDelta: span.longitudeDelta)
    }
}

extension Region {
    var mkCoordinateRegion: MKCoordinateRegion {
        MKCoordinateRegion(center: self.center.clLocationCoordinate2D, 
                           span: self.span.mkCoordinateSpan)
    }
    
    init?(_ region: MKCoordinateRegion) {
        guard let center = Coordinate(region.center)
        else { return nil }
        self.init(center: center, 
                  span: Span(region.span))
    }
    
    func printInitalizer() {
        let r = self.mkCoordinateRegion
        print("Region(MKCoordinateRegion(center: .init(latitude: \(r.center.latitude), longitude: \(r.center.longitude)), span: .init(latitudeDelta: \(r.span.latitudeDelta), longitudeDelta: \(r.span.longitudeDelta))))!")
    }
    
    static let start = Region(MKCoordinateRegion(center: .init(latitude: 49.288736748693054, longitude: -123.13784408424536), span: .init(latitudeDelta: 0.016335940297629747, longitudeDelta: 0.01166721364521095)))!
    
    static let cityHall = Region(center: .cityHall, span: Span(latitudeDelta: 0.008, longitudeDelta: 0.008))
}

// Coordinate sample values
extension Coordinate {
    static let cityHall   = Coordinate(latitude:    49.26091906953974,
                                       longitude: -123.11397548064534)!
    static let lostLagoon = Coordinate(latitude:    49.29438528642601,
                                       longitude: -123.13785887586177)!
    
    static func randomVancouver() -> Coordinate {
        let lat = 49.25...49.30
        let lng = -123.15...(-123.10)
        return Coordinate(latitude:  Double.random(in: lat),
                          longitude: Double.random(in: lng))!
    }
}

// Hashable Conformance
extension CLLocationCoordinate2D: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

extension MKCoordinateSpan: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitudeDelta)
        hasher.combine(longitudeDelta)
    }
    public static func == (lhs: MKCoordinateSpan, rhs: MKCoordinateSpan) -> Bool {
        lhs.latitudeDelta == rhs.latitudeDelta && lhs.longitudeDelta == rhs.longitudeDelta
    }
}

extension MKCoordinateRegion: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(center)
        hasher.combine(span)
    }
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        lhs.center == rhs.center && lhs.span == rhs.span
    }
}
