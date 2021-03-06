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
        self.init(coordinate: station.coordinate)
    }
}

struct StationsMapView: View {
    @ObservedObject var viewModel: StationsViewModel

    var body: some View {
        NavigationView {
            Map(coordinateRegion: viewModel.$region,
            showsUserLocation: true,
            annotationItems: viewModel.stations,
            annotationContent: MapMarker.init)
        }
        .navigationTitle("Mo'Bikes")
    }
}

struct StationsMapView_Previews: PreviewProvider {
    static var previews: some View {
        StationsMapView(viewModel: .init())
    }
}
