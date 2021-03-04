import Combine
import CoreLocation
import SwiftUI

public struct StationCard: View {
    let station: Station
    let location: CLLocation
    
    public var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                Text(station.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("\(station.location.distance(from: location).asUnitString()) away")
                    .fontWeight(.semibold)
                
            }
            AvailabilityView(available: station.availableBikes, total: station.totalSlots)
        }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            
            .foregroundColor(.white)
            .padding()
            .background(RoundedRectangle(cornerRadius: 15)
                            .fill(Color.accentColor)
            )
            .padding([.leading, .trailing])
        
    }
    
    public init(station: Station, location: CLLocation) {
        self.station = station
        self.location = location
    }
}

struct StationCard_Previews: PreviewProvider {
    static var previews: some View {
        StationCard(station: Station.examples[0],
                    location: Location.cityHall)
            .previewLayout(PreviewLayout.fixed(width: 272, height: 340))
        StationCard(station: Station.examples[1],
                    location: Location.lostLagoon)
            .previewLayout(PreviewLayout.fixed(width: 272, height: 340))
            .preferredColorScheme(.dark)
            .accentColor(.purple)
        
        
    }
}
