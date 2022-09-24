import SwiftUI

struct Whimsy: View {
    
    static let offset: CGFloat = 60
    static let duration: Double = 0.85
    
    @State var bikeOffset: CGFloat = 0
    @State var emojiOffset: CGFloat = -Whimsy.offset
    @Binding var orientation: CGFloat
    
    var body: some View {
        Button { 
            withAnimation(.easeIn(duration: Whimsy.duration)) { 
                bikeOffset = Whimsy.offset
                emojiOffset = 0
            } 
            Task {
                try await Task.sleep(nanoseconds: 2_000_000_000) 
                bikeOffset = -Whimsy.offset
                
                withAnimation(.easeOut(duration: Whimsy.duration)) {
                    bikeOffset = 0
                    emojiOffset = Whimsy.offset
                }
                try await Task.sleep(nanoseconds: 2_000_000_000) 
                emojiOffset = -Whimsy.offset
            }
        } label: {
            ZStack {
//                
//                Image("bikeIcon")
//                    .renderingMode(.template)
//                    .resizable()
//                    .scaledToFit()
//                    .offset(x: bikeOffset, y: 0)x
                Image(systemName: "bicycle")
                    .offset(x: bikeOffset, y: 0)
                Text("💖")
                    .offset(x: emojiOffset, y: 0)
            }
            .rotationEffect(.degrees(orientation))
        }
    }
}

struct Controls: View {
    @EnvironmentObject var sm: StateManager
    
    @State var bikeOffset: CGFloat = 0
    @State var orientation: CGFloat = 0.0
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                Whimsy(orientation: $orientation)
                .frame(width: 36, height: 44)
                
                Divider().frame(width: 44)
                Button { sm.action(.toLostLagoon) } label: { 
                    Image(systemName: "location")
                }              
                .frame(width: 44, height: 44)
                
                Divider().frame(width: 44)
//                Button { sm.action(.throwSampleError) } label: { 
                Button { wiggle() } label: { 
                        Image(systemName: "square.3.stack.3d")
                }          
                .frame(width: 44, height: 44)
                
                Divider().frame(width: 44)
                Button { sm.action(.updateStations) } label: { 
//                Button { sm.toggler.toggle() } label: { 
                        Image(systemName: "ellipsis.circle")
                }
                .frame(width: 44, height: 44)
                
                
            }
            .font(Font.system(size: 20))
            .background()
            .cornerRadius(10)
            
        }
        .padding([.trailing], 10)
    }
    
    func wiggle() {
        let time: UInt64 = 200_000_000
        Task {
            withAnimation { 
                orientation = 5
            }
            try await Task.sleep(nanoseconds: time) 
            withAnimation { 
                orientation = -5
            }
            try await Task.sleep(nanoseconds: time) 
            withAnimation { 
                orientation = 0
            }
        }
    }
}

struct MainView: View {
    @EnvironmentObject var sm: StateManager
    
    var body: some View {
        ZStack(alignment: .trailing) {
            VStack(alignment: .center) {
                if let error = sm.state.activeError {
                    ErrorView(error: error, clear: { sm.action(.clearError) })
                }
                MapView()
            }
            Controls()
        }
    }
}
