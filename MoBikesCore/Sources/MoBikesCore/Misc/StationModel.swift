import MapKit

public class Station: NSObject, Codable, MKAnnotation {
    let rawName: String
    let rawCoordinates: String
    let freeDocks: Int
    let availableBikes: Int
    let totalSlots: Int
    public let operative: Bool
    
    lazy public var name = { String(rawName.dropFirst(5))
        .replacingOccurrences(of: "Stanley Park - ", with: "")
    }()
    lazy public var coordinate = { convertRawCoordinates(rawCoordinates, CoordinateOrder.latFirst) }()
    lazy public var location = { CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude) }()
    
    lazy public var title: String? = { name }()
    
    public var subtitle: String? { "\(availableBikes) / \(totalSlots)" }
    
    enum CodingKeys: String, CodingKey {
        case rawName = "name"
        case rawCoordinates = "coordinates"
        case freeDocks = "free_slots"
        case availableBikes = "avl_bikes"
        case totalSlots = "total_slots"
        case operative
    }
    
    public struct Group: Decodable {
        public let stations: [Station]
        
        enum CodingKeys: String, CodingKey {
            case stations = "result"
        }
    }
    
    private init(rawName: String, rawCoordinates: String, freeDocks: Int, availableBikes: Int, operative: Bool = true) {
        self.rawName = rawName
        self.rawCoordinates = rawCoordinates
        self.freeDocks = freeDocks
        self.availableBikes = availableBikes
        self.totalSlots = freeDocks + availableBikes
        self.operative = operative
    }
    
}

extension Station {
    public override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? Station {
            return
                self.rawName == object.rawName &&
                self.rawCoordinates == object.rawCoordinates &&
                self.freeDocks == object.freeDocks &&
                self.availableBikes == object.availableBikes &&
                self.totalSlots == object.totalSlots &&
                self.operative == object.operative
        }
        return false
    }
}

extension Station {
    public convenience init(bikes availableBikes: Int, docks freeDocks: Int, _ name: String, _ rawCoordinates: String = "49.263962, -123.112621", _ operative: Bool = true) {
        self.init(rawName: "0000 " + name,
                  rawCoordinates: rawCoordinates,
                  freeDocks: freeDocks,
                  availableBikes: availableBikes,
                  operative: operative)}
    
    static public let examples: [Station] = [
        Station(bikes: 31, docks: 1, "10th & Cambie", "49.262487, -123.114397"),
        Station(bikes: 5, docks: 11, "12th & Yukon (City Hall)", "49.260599, -123.113504"),
        Station(bikes: 4, docks: 10, "8th & Yukon", "49.263962, -123.112621"),
        Station(bikes: 5, docks: 11, "Information Booth", "49.260599, -123.113504"),
        Station(bikes: 5, docks: 11, "Coal Harbour Community Centre", "49.260599, -123.113504"),
        
    ]
}

struct NewStation: Identifiable {
    typealias Available = (bikes: Int, docks: Int)
    typealias ID = String
    let id: String
    let name: String
    let available: Available
    let coordinates: CLLocationCoordinate2D
}

struct DecodableStation: Decodable {
    let name: String
    let coordinates: String
    let free_slots: Int
    let avl_bikes: Int
    let operative: Bool
    
    public struct Group: Decodable {
        public let result: [DecodableStation]
    }
}

extension DecodableStation {
    static func cleanName(_ rawName: String) -> String {
        String(rawName.dropFirst(5))
            .replacingOccurrences(of: "Stanley Park - ", with: "")
    }
    
    static func convertToStations(_ decodableStationGroup: DecodableStation.Group) -> [NewStation] {
        return decodableStationGroup.result
            .compactMap { decodedStation -> NewStation? in
                guard decodedStation.operative else { return nil }
                return NewStation(id: decodedStation.name,
                           name: cleanName(decodedStation.name),
                           available: (bikes: decodedStation.avl_bikes,
                                       docks: decodedStation.free_slots),
                           coordinates: convertRawCoordinates(decodedStation.coordinates,
                                                              CoordinateOrder.latFirst))
            }
    }
}

extension NewStation {
    init(_ bikes: Int, of total: Int,
         _ name: String,
         _ coordinates: CLLocationCoordinate2D = Coordinates.randomVancouver()) {
        self.init(id: UUID().uuidString,
                  name: name,
                  available: (bikes, total - bikes),
                  coordinates: coordinates)
    }
    
    static public let examples: [NewStation] = [
        .init(25, of: 30, "10th & Cambie", .init(latitude: 49.262487, longitude: -123.114397)),
        .init( 5, of: 11, "12th & Yukon (City Hall)", .init(latitude: 49.260599, longitude: -123.113504)),
        .init( 4, of: 10, "8th & Yukon", .init(latitude: 49.263962, longitude: -123.112621)),
        .init(11, of: 16, "Information Booth", .init(latitude: 49.260599, longitude: -123.113504)),
        .init( 2, of: 12, "Coal Harbour Community Centre", .init(latitude: 49.260599, longitude: -123.113504))
    ]
}
