import MapKit

public struct Station: Identifiable, Equatable, Hashable {
    public typealias ID = String

    public let id: String
    public let name: String
    public let available: Available
    public let coordinate: CLLocationCoordinate2D
}

extension Station {
    public struct Available: Equatable, Hashable {
        public let bikes: Int
        public let docks: Int
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

    static func convertToStations(_ decodableStationGroup: DecodableStation.Group) -> [Station] {
        return decodableStationGroup.result
            .compactMap { decodedStation -> Station? in
                guard decodedStation.operative else { return nil }
                return Station(id: decodedStation.name,
                               name: cleanName(decodedStation.name),
                               available: .init(bikes: decodedStation.avl_bikes,
                                                docks: decodedStation.free_slots),
                               coordinate: convertRawCoordinates(decodedStation.coordinates,
                                                                 CoordinateOrder.latFirst))
            }
    }
}

extension Station {
    init(_ bikes: Int, of total: Int,
         _ name: String,
         _ coordinate: CLLocationCoordinate2D = Coordinates.randomVancouver()) {
        self.init(id: UUID().uuidString,
                  name: name,
                  available: .init(bikes: bikes,
                                   docks: total - bikes),
                  coordinate: coordinate)
    }

    static public let examples: [Station] = [
        .init(25, of: 30, "10th & Cambie",
              .init(latitude: 49.262487, longitude: -123.114397)),

        .init( 5, of: 11, "12th & Yukon (City Hall)",
               .init(latitude: 49.260599, longitude: -123.113504)),

        .init( 4, of: 10, "8th & Yukon",
               .init(latitude: 49.263962, longitude: -123.112621)),

        .init(11, of: 16, "Information Booth",
              .init(latitude: 49.260599, longitude: -123.113504)),

        .init( 2, of: 12, "Coal Harbour Community Centre",
               .init(latitude: 49.260599, longitude: -123.113504))
    ]
}
