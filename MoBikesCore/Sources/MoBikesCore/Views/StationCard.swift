import Combine
import CoreLocation
import SwiftUI

public struct StationCard: View {
    let station: Station
    let location: CLLocation
    private let distanceString: String
    
    public var body: some View {
        
        VStack(alignment: .center, spacing: 0) {
            Text(station.name)
                .font(Font.system(size: 27, weight: .semibold, design: .rounded))
                .multilineTextAlignment(.center)
            HStack {
                Spacer()
                IconWithNumber(name: "bikeIcon", number: station.availableBikes)
                Spacer()
                IconWithNumber(name: "dockIcon", number: station.freeDocks)
                Spacer()
            }
            Text("\(distanceString) away")
                .fontWeight(.semibold)
                .font(Font.system(size: 16, weight: .semibold, design: .rounded))

        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .foregroundColor(.white)
        .padding()
        .background(RoundedRectangle(cornerRadius: 15)
                        .fill(Color.accentColor))
        
    }
    
    public init(station: Station, location: CLLocation) {
        self.station = station
        self.location = location
        self.distanceString = station.location.distance(from: location).asUnitString()
    }
}

struct IconWithNumber: View {
    let name: String
    let number: Int
    
    public var body: some View {

        HStack {
            Text(String(number))
                .font(Font.system(size: 27, weight: .regular, design: .rounded))
            Image(name, bundle: Bundle.module)
                .resizable()
                .frame(width: 27, height: 27)
                .aspectRatio(contentMode: .fit)

        }
    }
}

struct StationCard_Previews: PreviewProvider {
    static var previews: some View {
        StationCard(station: Station.examples[2],
                    location: Coordinates.cityHall.location)
            .previewDevice("Apple Watch Series 6 - 40mm")
            .accentColor(.purple)

        
        StationCard(station: Station(bikes: 23, docks: 3, "Information Booth"),
                    location: Coordinates.cityHall.location)
            .previewDevice("Apple Watch Series 6 - 40mm")
            .accentColor(.purple)
        
        StationCard(station: Station.examples[4],
                    location: Coordinates.cityHall.location)
            .previewDevice("Apple Watch Series 6 - 40mm")
            .accentColor(.purple)


        
//        StationCard(station: Station.examples[1],
//                    location: Location.lostLagoon)
//            .previewLayout(PreviewLayout.fixed(width: 400, height: 600))
//            .preferredColorScheme(.dark)
//            .accentColor(.purple)
        
        
    }
}
