//
//  SwiftUIView.swift
//  
//
//  Created by Andrew on 2021-03-05.
//

import SwiftUI
import MapKit
import Combine

extension MapMarker {
    init(_ station: Station) {
        let color = Style.Color.marker
        let tint = station.available.bikes > 2 ? color.normal : color.low
        self.init(coordinate: station.coordinate, tint: tint)
    }
}

struct StationsMapView: View {
    @State var region: MKCoordinateRegion
    let stations: [Station]

    var body: some View {
        Map(coordinateRegion: $region,
            showsUserLocation: true,
            annotationItems: stations,
            annotationContent: MapMarker.init)
    }

}

struct StationsMapView_Previews: PreviewProvider {
    static var previews: some View {
        StationsMapView(region: Coordinates.cityHall.region(),
                        stations: Station.examples)
    }
}
