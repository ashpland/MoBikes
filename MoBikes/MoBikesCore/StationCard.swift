//
//  StationCard.swift
//  MoBikes
//
//  Created by Andrew on 2021-02-27.
//

import SwiftUI

public struct StationCard: View {
    let station: Station
    
    public var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(station.name)
                Text(station.subtitle!)
            }
            Text("\(station.location.distance(from: Current.location()).asUnitString()) away")
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
            .previewLayout(PreviewLayout.sizeThatFits)
            .padding()
        StationCard(station: Station.examples[1])
            .previewLayout(PreviewLayout.sizeThatFits)
            .padding()
        StationCard(station: Station.examples[2])
            .previewLayout(PreviewLayout.sizeThatFits)
            .padding()

    }
}
