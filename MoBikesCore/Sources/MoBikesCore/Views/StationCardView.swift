import Combine
import CoreLocation
import SwiftUI

public struct StationCardView: View {
    let station: Station
    private let distanceString: String?

    public var body: some View {

        VStack(alignment: .center, spacing: 0) {
            Text(station.name)
                .font(Font.system(size: 27, weight: .semibold, design: .rounded))
                .multilineTextAlignment(.center)
            HStack {
                Spacer()
                IconWithNumber(name: "bikeIcon", number: station.available.bikes)
                Spacer()
                IconWithNumber(name: "dockIcon", number: station.available.docks)
                Spacer()
            }
            distanceString.map {
                Text("\($0) away")
                    .fontWeight(.semibold)
                    .font(Font.system(size: 16, weight: .semibold, design: .rounded))
                }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .foregroundColor(.white)
        .padding()
        .background(RoundedRectangle(cornerRadius: 15)
                        .fill(Color.Mo.primary))

    }

    public init(station: Station, location: CLLocation?) {
        self.station = station
        if let location = location {
            self.distanceString = station.coordinate.distance(from: location).asUnitString()
        } else {
            self.distanceString = nil
        }
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

struct StationCardView_Previews: PreviewProvider {
    static var previews: some View {
        StationCardView(station: Station.examples[2],
                    location: Coordinates.cityHall.location)
            .previewDevice("Apple Watch Series 6 - 40mm")

        StationCardView(station: .init(23, of: 26, "Information Booth"),
                    location: Coordinates.cityHall.location)
            .previewDevice("Apple Watch Series 6 - 40mm")

        StationCardView(station: Station.examples[4],
                    location: nil)
            .previewDevice("Apple Watch Series 6 - 40mm")

//        StationCard(station: Station.examples[1],
//                    location: Location.lostLagoon)
//            .previewLayout(PreviewLayout.fixed(width: 400, height: 600))
//            .preferredColorScheme(.dark)

    }
}
