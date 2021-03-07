import SwiftUI
import UIKit

let shape = Circle()

struct AvailabilityView: View {
    
    let available: Station.Available
    let simple: Bool
    
    internal init(available: Station.Available, simple: Bool = false) {
        self.available = available
        self.simple = simple
    }
    
    
    private var percentage: CGFloat {
        CGFloat(available.bikes) / CGFloat(available.bikes + available.docks)
    }
    
    private let borderConstant: CGFloat = 2
    
    static let aspectRatio: CGFloat = 1
    
    private var color: Color {
        let markerColor = Color.Mo.marker
        return available.bikes > Constants.lowBikes ? markerColor.normal : markerColor.low
    }
    
    var body: some View {
        if simple {
            SimpleAvailabilityView(available: available)
        } else {
            GeometryReader { geometry in
                ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                    shape.fill(Color.clear)
                    shape.stroke(color, style: .init(lineWidth: 2))
                    
                    FillAndIcon(fillColor: .white,
                                iconColor: color,
                                height: (geometry.size.height))
                    
                    FillAndIcon(fillColor: color,
                                iconColor: .white,
                                height: (geometry.size.height))
                        .frame(height: geometry.size.height * percentage, alignment: .bottom)
                        .clipped()
                    
                }
                .padding([.horizontal], 1)
                
            }
            .aspectRatio(AvailabilityView.aspectRatio, contentMode: .fit)
            .frame(height: 30)
            
        }
    }
}

struct FillAndIcon: View {
    let fillColor: Color
    let iconColor: Color
    let height: CGFloat
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
            shape.fill(fillColor)
            Image("bikeIcon-small", bundle: Bundle.module)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(iconColor)
        }
        .frame(height: height)
    }
}

struct SimpleAvailabilityView: View {
    let available: Station.Available
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            shape.fill(Color.Mo.marker.normal)
            shape.stroke(Color.white, style: .init(lineWidth: 0.5))
        }
        .padding([.horizontal], 1)
        
        .aspectRatio(AvailabilityView.aspectRatio, contentMode: .fit)
        
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        AvailabilityView(available: .init(bikes: 7, docks: 10))
            .previewLayout(PreviewLayout.fixed(width: 100, height: 200))
            .background(Color.gray)

        
        AvailabilityView(available: .init(bikes: 1, docks: 10))
            .previewLayout(PreviewLayout.fixed(width: 100, height: 200))
            .preferredColorScheme(.dark)
            .background(Color.gray)

        SimpleAvailabilityView(available: .init(bikes: 3, docks: 10))
            .previewLayout(PreviewLayout.fixed(width: 40, height: 100))
        
        SimpleAvailabilityView(available: .init(bikes: 1, docks: 10))
            .previewLayout(PreviewLayout.fixed(width: 40, height: 100))
        
        
    }
}
