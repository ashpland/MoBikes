//
//  StationsView.swift
//  MoBikesCore
//
//  Created by Andrew on 2021-02-28.
//

import SwiftUI
import Combine

public struct StationsView: View {
    @ObservedObject var stationGetter = StationGetter()
    
    public var body: some View {
        if stationGetter.stations.isEmpty {
            ProgressView()
        } else {
            ScrollView {
                VStack {
                    ForEach(stationGetter.stations, id: \.self) { station in
                        StationCard(station: station)
                        Divider()
                    }
                }
            }
        }
    }
    
    public init() { }
    
    final class StationGetter: ObservableObject {
        let objectWillChange = PassthroughSubject<Void, Never>()
        var stations: [Station] = [] {
            willSet {
                objectWillChange.send()
            }
        }
        
        init() {
            DispatchQueue.main.async {
                self.updateStations()
            }
        }
        
        func updateStations() {
            Current.stations { result in
                if case .success(let stations) = result {
                    let operativeStations = stations
                        .filter { $0.operative }
                    
                    if let last = stations.last {
                        print (last.name)
                    }
                    
                    DispatchQueue.main.async {
                        self.stations = operativeStations
                        
                    }
                }
            }
        }
    }
}

struct StationsView_Previews: PreviewProvider {
    static var previews: some View {
        StationsView()
//            .previewDevice("Apple Watch Series 6 - 40mm")
            .previewLayout(PreviewLayout.fixed(width: 300, height: 600))
        
    }
}
