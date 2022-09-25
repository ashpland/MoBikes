import SwiftUI

struct LayerToggle: View {
    let title: String
    let systemImage: String
    let color: Color
    let palette: Bool
    let kp: WritableKeyPath<iosState.UI, Bool>
    @State private var isOn: Bool = false
    @EnvironmentObject var sm: StateManager<iosState>
    
    private var foreground: Color {
        switch (isOn, palette) {
        case (false, false):
            return .gray
        case (true, false):
            return color
        case (_, true):
            return .white
        }
    }

    var body: some View {
        Toggle(isOn: $isOn) {
            HStack {
                Image(systemName: systemImage)
                    .frame(width: 40, alignment: .center)
                    .foregroundStyle(foreground, isOn ? color : .gray)
                    .symbolRenderingMode(.palette)
                Text(title)
                    .foregroundColor(isOn ? color : .gray)
            }
            .font(Font.system(.title, design: .rounded))
            .onTapGesture {
                isOn.toggle()
            }
        }
        .toggleStyle(SwitchToggleStyle(tint: color))
        .onChange(of: isOn, perform: { sm.dispatch(.platform(.updateUIBool(.init(kp: kp, value: $0)))) })
        .onReceive(sm.$db.map(\.ui).map(kp), perform: { self.isOn = $0 })
    }
}

struct LayerToggle_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            LayerToggle(title: "Mobi Stations", systemImage: "bicycle.circle.fill",
                        color: .purple, palette: true, kp: \.mapSettings.showStations)
            LayerToggle(title: "Bike Routes", systemImage: "chevron.forward.2",
                        color: .green, palette: false, kp: \.mapSettings.showBikeways)
            LayerToggle(title: "Water Fountains", systemImage: "drop.fill",
                        color: .blue, palette: false, kp: \.mapSettings.showFountains)
            LayerToggle(title: "Public Toilets", systemImage: "figure.stand",
                        color: .pink, palette: false, kp: \.mapSettings.showToilets)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.secondaryBackground)
        .environmentObject(StateManager(iosState()))
        .environment(\.colorScheme, .dark)
    }
}

struct LayersView: View {
    var body: some View {
        VStack(spacing: -10) {
            Color.secondaryBackground
                .frame(maxWidth: .infinity, maxHeight: 20)
                .cornerRadius(50)
                .shadow(radius: 8)
            VStack {
                LayerToggle(title: "Mobi Stations", systemImage: "bicycle.circle.fill",
                            color: .purple, palette: true, kp: \.mapSettings.showStations)
                LayerToggle(title: "Bike Routes", systemImage: "chevron.forward.2",
                            color: .green, palette: false, kp: \.mapSettings.showBikeways)
                LayerToggle(title: "Water Fountains", systemImage: "drop.fill",
                            color: .blue, palette: false, kp: \.mapSettings.showFountains)
                LayerToggle(title: "Public Toilets", systemImage: "figure.stand",
                            color: .pink, palette: false, kp: \.mapSettings.showToilets)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.secondaryBackground)
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .zIndex(1)
        .transition(.move(edge: .bottom))
    }
}

struct LayersView_Preview: PreviewProvider {
    static var previews: some View {
        LayersView()
            .environmentObject(StateManager(iosState()))
            .environment(\.colorScheme, .dark)
    }
}
