//
//  StationCard.swift
//  MoBikes
//
//  Created by Andrew on 2021-02-27.
//

import SwiftUI
import MoBikesCore

struct StationCard: View {
    let station: Station
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(station.name)
                Text(station.subtitle!)
            }
            Text("\(station.coordinate.latitude), \(station.coordinate.longitude)")
        }
    }
}

struct StationCard_Previews: PreviewProvider {
    static var previews: some View {
        StationCard(station: Station.example)
            .previewLayout(PreviewLayout.sizeThatFits)
            .padding()

    }
}
