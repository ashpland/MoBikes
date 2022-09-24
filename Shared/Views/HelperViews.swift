import SwiftUI

struct ErrorView: View {
    let error: MBError
    let clear: () -> Void
    
    var body: some View {
        VStack(alignment: .leading){
            Text(error.userDescription)
            Text(error.debugDescription)
            Button("Clear Error") {
                clear()
            }
        }
        .padding()
    }
}
