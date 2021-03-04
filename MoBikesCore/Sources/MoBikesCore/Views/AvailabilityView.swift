import SwiftUI

struct AvailabilityView: View {
    let available: Int
    let total: Int
    
    private var percentage: CGFloat {
        CGFloat(available) / CGFloat(total)
    }
    
    private let borderConstant: CGFloat = 2
    
    static let aspectRatio: CGFloat = 0.7
    
    var body: some View {
            GeometryReader { geometry in
                ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                    Rectangle().fill(Color.white)
                        .cornerRadius(borderConstant * 2)

                    FillAndIcon(fillColor: .white, iconColor: .accentColor,
                                height: (geometry.size.height - (borderConstant * 2)))
                        .cornerRadius(borderConstant * 2)
                        .padding(borderConstant)
                    
                    FillAndIcon(fillColor: .accentColor, iconColor: .white,
                                height: (geometry.size.height - (borderConstant * 2)))
                        .cornerRadius(borderConstant * 2)
                        .padding(borderConstant)
                        .frame(height: geometry.size.height * percentage, alignment: .bottom)
                        .clipped()

                    
                }
        }
        .aspectRatio(AvailabilityView.aspectRatio, contentMode: .fit)
        
    }
}

struct FillAndIcon: View {
    let fillColor: Color
    let iconColor: Color
    let height: CGFloat
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
            Rectangle()
                .fill(fillColor)
            Image(systemName: "car.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(iconColor)
                .frame(maxWidth: 15)
        }
        .frame(height: height)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        AvailabilityView(available: 7, total: 10)
            .previewLayout(PreviewLayout.fixed(width: 100, height: 200))
            .background(Color.accentColor)
            .accentColor(.purple)

        
        AvailabilityView(available: 1, total: 10)
            .previewLayout(PreviewLayout.fixed(width: 100, height: 200))
            .preferredColorScheme(.dark)
            .background(Color.accentColor)

    }
}
