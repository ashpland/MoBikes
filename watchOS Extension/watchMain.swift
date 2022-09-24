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
                    .accentColor(.purple)
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
            NavigationView {
                List {
                    Button {
                        print("Edit button was tapped")
                    } label: {
                        Label("Nearby Stations", systemImage: "mappin.and.ellipse")
                            .symbolRenderingMode(.hierarchical)
                    }
                    ForEach(sm.db.stationsByDistanceFromCurrentLocation) { station in
                        StationCard(station: station)
                    }
                }
                .navigationTitle("Mo'Bikes")
            }
            
        }
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(StateManager(watchState() |>
                                            assoc(\.stations, Station.examples)
                                            >>> assoc(\.world.locationClient, .lostLagoon)))
            .accentColor(.purple)
    }
}
