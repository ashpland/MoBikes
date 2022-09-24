import SwiftUI

@main
struct MoBikesApp: App {
    let sm = StateManager(watchState())
    
    init() {
        sm.dispatchAsync(.updateStations)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainView()
                    .environmentObject(sm)
            }
        }
    }
}

struct MainView: View {
    @EnvironmentObject var sm: StateManager<watchState>
   
    var body: some View {
        if (sm.db.stations.isEmpty) {
            Text("Loading Stations...")
        } else {
            List {
                ForEach(sm.db.stations, content: StationCard.init)
            }
            .accentColor(.purple)
        }
    }
}

struct Main_Previews: PreviewProvider {
    static let previewState = { watchState() |>
        assoc(\.stations, Station.examples) }()
    
    static var previews: some View {
        MainView()
            .environmentObject(StateManager(previewState))
    }
}

struct StationCard: View {
    let station: Station
    
    var body: some View {
        HStack {
            Text(station.name)
            Spacer()
            Text("\(station.available.bikes) / \(station.available.total)")
        }
        .padding(.vertical)
        .listRowBackground(StationCardBackground(available: station.available))
        

    }
}

struct StationCardBackground: View {
    let available: Station.Available
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.15)
            AvailabilityBar(available: available)
                .opacity(0.4)
        }
        .cornerRadius(12)
    }
}

extension Station.Available {
    var percent: CGFloat {
        return Double(self.bikes) / Double(self.total)
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
