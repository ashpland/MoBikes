import SwiftUI

@main
struct MoBikesApp: App {
    let sm = StateManager(iosState())
    
    init() {
        sm.dispatchAsync(.updateStations)
        sm.startTimer(.updateStations, seconds: StationApi.updateFrequency)
        sm.dispatch(.platform(.loadBikeways))
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(sm)
                .accentColor(.purple)
        }
    }
}

struct MainView: View {
    @EnvironmentObject var sm: StateManager<iosState>
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        ZStack {
            ErrorAlertView<iosState>()

            MapView().ignoresSafeArea()
            
            if sm.db.ui.showLayersView { LayersView() }
    
            SimpleControls()
                .padding([.trailing], 10)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .animation(.default, value: sm.db.ui)
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

struct Main_Preview: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(StateManager(iosState() |> assoc(\.stations, Station.examples)
                                            >>> assoc(\.world.locationClient, .cityHall)))
            .accentColor(.purple)
            .environment(\.colorScheme, .dark)
    }
}
