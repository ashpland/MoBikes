import MapKit
import SwiftUI

struct StationsMap: View {
    let stations: [Station]
    @State private var region: MKCoordinateRegion
    
    init(_ stations: [Station], _ region: Region) {
        self.stations = stations
        self.region = region.mkCoordinateRegion
    }

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: stations) {
            MapMarker(coordinate: $0.coordinate.clLocationCoordinate2D)
        }
    }
}

struct StationsMap_Previews: PreviewProvider {
    static var previews: some View {
        StationsMap(Station.examples,
                    Region(center: Station.examples.first!.coordinate,
                           span: .init(latitudeDelta: 0.006, longitudeDelta: 0.006)))
    }
}
