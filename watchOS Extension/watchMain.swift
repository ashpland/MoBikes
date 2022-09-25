import SwiftUI
import Combine

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
    @State var displayError: Bool = false

    var body: some View {
        if (sm.db.stations.isEmpty) {
            Text("Loading Stations...")
        } else {
            NavigationView {
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
                .alert(sm.db.activeError?.userDescription ?? "",
                       isPresented: $displayError) {
                    Button("Clear") { sm.dispatch(.clearError) }
                } message: {
                    Text(sm.db.activeError?.debugDescription ?? "")
                }
            }
            .onReceive(sm.$db.map(\.activeError)) { self.displayError = $0 != nil }
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
