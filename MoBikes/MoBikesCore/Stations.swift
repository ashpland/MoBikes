//
//  Stations.swift
//  MoBikesCore
//
//  Created by Andrew on 2021-02-27.
//

import MapKit

public class Station: NSObject, Codable, MKAnnotation {
    let rawName: String
    let rawCoordinates: String
    let freeSlots: Int
    let availableBikes: Int
    let totalSlots: Int
    let operative: Bool
    
    lazy public var name = { String(rawName.dropFirst(5)) }()
    lazy public var coordinate = { convertRawCoordinates(rawCoordinates, CoordinateOrder.latFirst) }()
        
    public var title: String? { name }
    
    public var subtitle: String? { "\(availableBikes) / \(totalSlots)" }
    
    enum CodingKeys: String, CodingKey {
        case rawName = "name"
        case rawCoordinates = "coordinates"
        case freeSlots = "free_slots"
        case availableBikes = "avl_bikes"
        case totalSlots = "total_slots"
        case operative
    }
    
    struct Group: Decodable {
        let stations: [Station]
        
        enum CodingKeys: String, CodingKey {
            case stations = "result"
        }
    }
}
