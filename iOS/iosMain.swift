import SwiftUI

@main
struct MoBikesApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(StateManager(iosState()))
        }
    }
}

struct MainView: View {
    @EnvironmentObject var sm: StateManager<iosState>
    
    var body: some View {
        ZStack(alignment: .trailing) {
            VStack(alignment: .center) {
                if let error = sm.db.activeError {
                    ErrorView(error: error, clear: { sm.dispatch(.clearError) })
                }
                MapView()
            }
            Controls()
                .padding([.trailing], 10)
        }
    }
}

struct Main_Preview: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(StateManager(iosState()))
            .previewLayout(.fixed(width: 500, height: 500))
    }
}
