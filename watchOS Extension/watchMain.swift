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
    @State var navigation: String? = nil
    @State var activeError: MBError? = nil

    var body: some View {
        if (sm.db.stations.isEmpty) {
            Text("Loading Stations...")
        } else {
            NavigationView {
                ZStack {
                    NavigationLink(destination: StationsMap(sm.db.stations, sm.db.currentLocation),
                                   tag: "Map", selection: $navigation) { }
                        .hidden()
                    List {
                        Button {
                            sm.dispatch(.throwSampleError)
                        } label: {
                            Label("Throw Error", systemImage: "xmark.octagon")
                                .symbolRenderingMode(.hierarchical)
                        }
                        Button {
                            sm.dispatch(.custom(.navigate(.map(sm.db.currentLocation))))
                        } label: {
                            Label("Nearby Stations", systemImage: "mappin.and.ellipse")
                                .symbolRenderingMode(.hierarchical)
                        }
                        ForEach(sm.db.stationsByDistanceFromCurrentLocation) { station in
                            StationCard(station: station)
                        }
                    }
                }
                .navigationTitle("Mo'Bikes")
                .alert(item: $activeError) { error in
                    Alert(title: Text(error.userDescription),
                          message: Text(error.debugDescription),
                          dismissButton: .cancel(Text("Clear"),
                                                 action: { sm.dispatch(.clearError)}))
                }
            }
            .onReceive(sm.$db.map(\.navigation.selection)) {
                print("recieved selection \($0 ?? "nil")")
                self.navigation = $0 }
            .onReceive(sm.$db.map(\.activeError)) {
                self.activeError = $0
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
