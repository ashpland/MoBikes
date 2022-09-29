import SwiftUI
import Combine

@main
struct MoBikesApp: App {
    let sm = StateManager(watchState())
    
    init() {
        sm.dispatchAsync(.updateStations)
        sm.startTimer(.updateStations, seconds: StationApi.updateFrequency)
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
    @Environment(\.scenePhase) var scenePhase
    @State var displayError: Bool = false

    var body: some View {
        if (sm.db.stations.isEmpty) {
            Text("Loading Stations...")
        } else {
            NavigationView {
                ErrorAlertView<watchState>()
                List {
                    NavigationLink {
                        StationsMap(sm.db.stations, sm.db.currentLocation)
                    } label: {
                        HStack {
                            Image(systemName: "bicycle.circle")
                                .font(.title2)
                                .foregroundStyle(.primary, .purple)
                                .symbolRenderingMode(.palette)
                                
                            Text("All Stations")
                        }
                    }
                    ForEach(sm.db.stationsByDistanceFromCurrentLocation) { station in
                        StationCard(station: station, allStations: sm.db.stations)
                    }
                }
                .navigationTitle("Mo'Bikes")
            }
            .onChange(of: scenePhase) { newPhase in
                switch newPhase {
                case .active:
                    sm.dispatchAsync(.updateStations)
                    sm.startTimer(.updateStations, seconds: StationApi.updateFrequency)
                case .background:
                    sm.stopTimer(.updateStations)
                default:
                    break
                }
            }
        }
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(StateManager(watchState() |>
                                            assoc(\.stations, Station.examples)
                                            >>> assoc(\.world.locationClient, .cityHall)))
            .accentColor(.purple)
    }
}
