//
//  Environment.swift
//  MoBikesCore
//
//  Created by Andrew on 2021-02-27.
//

import Foundation
import MapKit

public struct Environment {
    public var location: () -> CLLocation
    public var stations: (@escaping (Result<[Station], Error>) -> Void) -> Void
}

let close = CLLocation(latitude: 49.26307047497602, longitude: -123.11455871130153)
let far   = CLLocation(latitude: 49.29235477443431, longitude: -123.13665159634905)

public let Current = Environment(location: { far },
                          stations: { $0(.success(Station.examples)) })
