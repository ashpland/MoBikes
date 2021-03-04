import Combine
import CoreLocation
import SwiftUI

public struct StationCard: View {
    let station: Station
    let location: CLLocation
    
    public var body: some View {
        
        VStack(alignment: .leading) {
            Text(station.name)
                .font(Font.system(size: 27, weight: .semibold, design: .rounded))
            HStack(spacing: 3) {
                
                Text("\(station.location.distance(from: location).asUnitString()) away")
                    .fontWeight(.semibold)
                    .font(Font.system(size: 16, weight: .semibold, design: .rounded))
                
                Spacer()
                AvailabilityView(available: station.availableBikes, total: station.totalSlots)
                    .frame(maxWidth: 30)
            }
        }
        //            .frame(maxHeight: geometry.size.width * 2)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        
        .foregroundColor(.white)
        .padding()
        .background(RoundedRectangle(cornerRadius: 15)
                        .fill(Color.accentColor))
        
    }
    
    public init(station: Station, location: CLLocation) {
        self.station = station
        self.location = location
    }
}

struct StationCard_Previews: PreviewProvider {
    static var previews: some View {
        StationCard(station: Station.examples[2],
                    location: Location.cityHall)
            .previewDevice("Apple Watch Series 6 - 40mm")
            .accentColor(.purple)

        
        StationCard(station: Station.examples[3],
                    location: Location.cityHall)
            .previewDevice("Apple Watch Series 6 - 40mm")
            .accentColor(.purple)
        
        StationCard(station: Station.examples[4],
                    location: Location.cityHall)
            .previewDevice("Apple Watch Series 6 - 40mm")
            .accentColor(.purple)


        
//        StationCard(station: Station.examples[1],
//                    location: Location.lostLagoon)
//            .previewLayout(PreviewLayout.fixed(width: 400, height: 600))
//            .preferredColorScheme(.dark)
//            .accentColor(.purple)
        
        
    }
}
