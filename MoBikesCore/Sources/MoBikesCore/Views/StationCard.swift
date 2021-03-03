import SwiftUI

public struct StationCard: View {
    let station: Station
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text(station.name)
                .font(.title2)
                .fontWeight(.light)
            HStack(alignment: .top) {
                Image(systemName: "location.fill")
                // Text("\(station.distance.asUnitString()) away")
                Spacer()
                Text(station.subtitle!)
            }
            .padding(EdgeInsets(top: 4, leading: 0, bottom: 0, trailing: 0))
            

        }
        .padding()
    }
    
    public init(station: Station) {
        self.station = station
    }
}

struct StationCard_Previews: PreviewProvider {
    static var previews: some View {
        StationCard(station: Station.examples[0])
            .previewLayout(PreviewLayout.fixed(width: 272, height: 340))
        StationCard(station: Station.examples[1])
            .previewLayout(PreviewLayout.fixed(width: 272, height: 340))
        StationCard(station: Station.examples[2])
            .previewLayout(PreviewLayout.fixed(width: 272, height: 340))
        
    }
}
