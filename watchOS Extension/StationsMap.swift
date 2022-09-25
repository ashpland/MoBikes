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

struct StationMarker: View {
    let station: Station
    
    var body: some View {
        GeometryReader { geom in
            ZStack() {
                ZStack(alignment: .bottom) {
                    Color.black
                    Color.white.opacity(0.15)
                    Color.accentColor.frame(height: geom.size.height * station.available.percent)
                }
                Text("\(station.available.bikes)")
                    .font(.system(.body, design: .rounded))
            }
        }
        .frame(width: 30, height: 30)
        .clipShape(Circle())
        .shadow(radius: 3)
    }
}

struct StationMarker_Previews: PreviewProvider {
    static var previews: some View {
        StationMarker(station: Station.examples[0]).accentColor(.purple)
        StationMarker(station: Station.examples[1]).accentColor(.purple)
        StationMarker(station: Station.examples[2]).accentColor(.purple)
    }
        
}
