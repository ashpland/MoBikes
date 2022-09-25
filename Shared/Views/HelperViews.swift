import SwiftUI

struct ErrorAlertView<DB: StateManageable>: View {
    @EnvironmentObject var sm: StateManager<DB>
    @State var displayError: Bool = false

    var body: some View {
        ZStack {}
            .onReceive(sm.$db.map(\.activeError)) { self.displayError = $0 != nil }
            .alert(sm.db.activeError?.userDescription ?? "",
                   isPresented: $displayError) {
                Button("Clear") { sm.dispatch(.clearError) }
            } message: {
                Text(sm.db.activeError?.debugDescription ?? "")
            }
    }
}
