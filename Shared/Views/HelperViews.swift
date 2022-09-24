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

struct QuickUIView<A: UIView>: UIViewRepresentable {
    let makeView: () -> A
    let updateView: ((A) -> ())?
    
    init(makeView: @escaping ()-> A, updateView: ((A) -> Void)? = nil) {
        self.makeView = makeView
        self.updateView = updateView
    }
    
    func makeUIView(context: Context) -> A {
        makeView()
    }
    
    func updateUIView(_ uiView: A, context: Context) {
        if let updateView = updateView {
            updateView(uiView)
        }
    }
}
