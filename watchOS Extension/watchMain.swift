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
        }
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
