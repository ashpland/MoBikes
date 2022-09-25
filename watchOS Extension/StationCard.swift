import SwiftUI

struct StationCard: View {    
    let station: Station
    let allStations: [Station]
    
    var body: some View {
        NavigationLink {
            StationsMap(allStations, station.coordinate)
        } label : {
            HStack {
                Text(station.name)
                Spacer()
                Text("\(station.available.bikes) / \(station.available.total)")
            }
            .padding(.vertical)
        }
        .listRowBackground(StationCardBackground(available: station.available))
    }
}

struct StationCardBackground: View {
    let available: Station.Available
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.15)
            AvailabilityBar(available: available)
        }
        .cornerRadius(10)
    }
}

struct AvailabilityBar: View {
    let available: Station.Available
    
    var body: some View {
        GeometryReader { geom in
            ZStack(alignment: .leading) {
                Color.accentColor.frame(width: geom.size.width * available.percent)
                
            }
        }
    }
}

struct Station_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ForEach(Station.examples) {
                StationCard(station: $0, allStations: Station.examples)
            }
        }
        .accentColor(.purple)
    }
}
