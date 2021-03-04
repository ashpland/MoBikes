import MapKit

public class Station: NSObject, Codable, MKAnnotation {
    let rawName: String
    let rawCoordinates: String
    let freeSlots: Int
    let availableBikes: Int
    let totalSlots: Int
    public let operative: Bool

    lazy public var name = { String(rawName.dropFirst(5)) }()
    lazy public var coordinate = { convertRawCoordinates(rawCoordinates, CoordinateOrder.latFirst) }()
    lazy public var location = { CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude) }()

    lazy public var title: String? = { name }()

    public var subtitle: String? { "\(availableBikes) / \(totalSlots)" }

    enum CodingKeys: String, CodingKey {
        case rawName = "name"
        case rawCoordinates = "coordinates"
        case freeSlots = "free_slots"
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

    private init(rawName: String, rawCoordinates: String, freeSlots: Int, availableBikes: Int, operative: Bool = true) {
        self.rawName = rawName
        self.rawCoordinates = rawCoordinates
        self.freeSlots = freeSlots
        self.availableBikes = availableBikes
        self.totalSlots = freeSlots + availableBikes
        self.operative = operative
    }

}

extension Station {
    public override func isEqual(_ object: Any?) -> Bool {
            if let object = object as? Station {
                return
                    self.rawName == object.rawName &&
                    self.rawCoordinates == object.rawCoordinates &&
                    self.freeSlots == object.freeSlots &&
                    self.availableBikes == object.availableBikes &&
                    self.totalSlots == object.totalSlots &&
                    self.operative == object.operative
            }
            return false
        }
}

extension Station {
    public convenience init(bikes availableBikes: Int, docks freeSlots: Int, _ rawCoordinates: String, _ name: String, _ operative: Bool = true) {
        self.init(rawName: "0000 " + name,
                  rawCoordinates: rawCoordinates,
                  freeSlots: freeSlots,
                  availableBikes: availableBikes,
                  operative: operative)}

    static public let examples: [Station] = [
        Station(bikes: 31, docks: 1, "49.262487, -123.114397", "10th & Cambie"),
        Station(bikes: 5, docks: 11, "49.260599, -123.113504", "12th & Yukon (City Hall)"),
        Station(bikes: 4, docks: 10, "49.263962, -123.112621", "8th & Yukon")]
}
