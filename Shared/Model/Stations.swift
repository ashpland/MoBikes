import MapKit

struct Station: Identifiable, Equatable, Codable {
    typealias ID = Tagged<Station, String>
    
    let id: ID
    let name: String
    let available: Available
    let coordinate: Coordinate
}

extension Station {
    struct Available: Equatable, Codable {
        let bikes: Int
        let docks: Int
        var total: Int { bikes + docks }
    }
}

extension Station.Available {
    var percent: CGFloat {
        return Double(self.bikes) / Double(self.total)
    }
}

extension Station {
    init?(decoded: DecodableStation) {
        guard decoded.operative,
              let coordinate = decoded.coordinates |> Coordinate.parse(.latitudeFirst)
        else { return nil }
        
        self.id = decoded.name.tagged()
        self.name = DecodableStation.cleanName(decoded.name)
        self.available = .init(bikes: decoded.avl_bikes,
                               docks: decoded.free_slots)
        self.coordinate = coordinate
    }
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
}

extension Station {
    init(_ bikes: Int, of total: Int,
         _ name: String,
         _ coordinate: Coordinate) {
        self.init(id: UUID().uuidString.tagged(),
                  name: name,
                  available: .init(bikes: bikes,
                                   docks: total - bikes),
                  coordinate: coordinate)
    }
    
    static let examples: [Station] = [
        .init(25, of: 30, "10th & Cambie",
              .init(latitude: 49.262487, longitude: -123.114397)!),
        .init( 5, of: 11, "12th & Yukon (City Hall)",
               .init(latitude: 49.260599, longitude: -123.113504)!),
        .init( 1, of: 10, "8th & Yukon",
               .init(latitude: 49.263962, longitude: -123.112621)!)
    ]
    
    static func random() -> Station {
        let total = Int.random(in: 8...30)
        let available = Int.random(in: 0...total)
        return .init(available, of: total, randomString(length: 10), .randomVancouver())
    }
    
    static let blank = Station(0, of: 0, "", .init(latitude: 0.0, longitude: 0.0)!)
}

extension Array where Element == Station {
    var hashOfIds: Int {
        self.map(\.id).sorted().hashValue
    }
}

