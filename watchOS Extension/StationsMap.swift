import MapKit
import SwiftUI

struct StationsMap: View {
    let stations: [Station]
    @State private var region: MKCoordinateRegion
    
    init(_ stations: [Station], _ center: Coordinate) {
        self.stations = stations
        self.region = Region(center: center,
                             span: .init(latitudeDelta: 0.006, longitudeDelta: 0.006))
        .mkCoordinateRegion
    }
    
    var body: some View {
        Map(coordinateRegion: $region, interactionModes: [.pan], showsUserLocation: true, annotationItems: stations) { station in
            MapAnnotation(coordinate: station.coordinate.clLocationCoordinate2D) {
                StationMarker(station: station)
            }
        }
        .accentColor(.purple)
        .ignoresSafeArea(edges: [.bottom, .horizontal])
    }
}

struct StationsMap_Previews: PreviewProvider {
    static var previews: some View {
        StationsMap(Station.examples, Station.examples.first!.coordinate)
        .accentColor(.purple)
    }
}
