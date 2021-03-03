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
    public var stationsClient: StationsClient = .live
}

private let near = CLLocation(latitude: 49.26307047497602, longitude: -123.11455871130153)
private let far  = CLLocation(latitude: 49.29235477443431, longitude: -123.13665159634905)

extension Environment {
    static let live = Environment()
    static let mock = Environment(location: { near },
                                  stationsClient: .mock)
    
}

public var Current: Environment = .live
