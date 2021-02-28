//
//  Environment.swift
//  MoBikesCore
//
//  Created by Andrew on 2021-02-27.
//

import Foundation
import MapKit

public struct Environment {
    public var location: () -> CLLocation = { near }
    public var stations: (@escaping (Result<[Station], Error>) -> Void) -> Void = getStations
}

private let near = CLLocation(latitude: 49.26307047497602, longitude: -123.11455871130153)
private let far  = CLLocation(latitude: 49.29235477443431, longitude: -123.13665159634905)

extension Environment {
    static let mock = Environment(location: { near },
                                  stations: { $0(.success(Station.examples)) })
    
    static let live = Environment()
}

public let Current = Environment.mock
