import SwiftUI

struct StationMarker: View {
    let station: Station
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        GeometryReader { geom in
            ZStack() {
                ZStack(alignment: .bottom) {
                    Color.black
                    Color.white.opacity(colorScheme == .dark ? 0.15 : 0.55)
//                    if (colorScheme == .dark) {
//                    } else {
//                        Color.black
//                        Color.white.opacity(0.55)
//                    }
                    Color.accentColor.frame(height: geom.size.height * station.available.percent)
                }
                Text("\(station.available.bikes)")
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.white)
            }
        }
        .frame(width: 30, height: 30)
        .clipShape(Circle())
        .shadow(radius: 3)
    }
}

struct StationMarker_Previews: PreviewProvider {
    static var previews: some View {
        StationMarker(station: Station.examples[0]).accentColor(.purple)
        StationMarker(station: Station.examples[1]).accentColor(.purple)
        StationMarker(station: Station.examples[2]).accentColor(.purple)
    }
        
}
