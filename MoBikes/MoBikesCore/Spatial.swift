//
//  Spatial.swift
//  MoBikesCore
//
//  Created by Andrew on 2021-02-27.
//

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
    public func pretty() -> String {
        if (self < 1000) {
            return String(format: "%.0f", self) + " m"
        } else {
            return String(format: "%.2f", self / 1000) + " km"
        }    }
}
