//
//  SwiftUIView.swift
//  
//
//  Created by Andrew on 2021-03-05.
//

import SwiftUI
import MapKit
import Combine

let cityHall = CLLocation(latitude: 49.263033443931576, longitude: -123.11300547666653).coordinate
let span = MKCoordinateSpan(latitudeDelta: 0.006, longitudeDelta: 0.006)

//func stationToMarker(_ station: StationStruct) -> MapMarker {
//    MapMarker(coordinate: station.coordinate)
//}
//
//struct SingleMapView: View {
//    @State var region: MKCoordinateRegion = .init(center: cityHall,
//                                                  span: span)
//
//
//    var body: some View {
//        NavigationView {
//        Map(coordinateRegion: $region,
//            showsUserLocation: true,
//            annotationItems: StationStruct.examples,
//            annotationContent: stationToMarker)
//        }
//        .navigationTitle("Hi")
//    }
//}
//
//struct SingleMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        SingleMapView()
//    }
//}
