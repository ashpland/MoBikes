import SwiftUI

struct AvailabilityView: View {
    let available: Int
    let total: Int
    
    private var percentage: CGFloat {
        CGFloat(available) / CGFloat(total)
    }
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
            GeometryReader { geometry in
                ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                    Rectangle().fill(Color.white)
                        .cornerRadius((geometry.size.width * 0.03) * 2)
                    Rectangle()
                        .fill(Color.accentColor)
                        .frame(maxWidth: geometry.size.width - ((geometry.size.width * 0.03) * 2),
                               maxHeight: (geometry.size.height - ((geometry.size.width * 0.03) * 2)) * percentage,
                               alignment: .bottom)
                        .cornerRadius((geometry.size.width * 0.03) * 2)
                        .padding(.bottom, (geometry.size.width * 0.03))
                }
            }
//            Image(systemName: "car.fill")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .foregroundColor(.white)
//                .frame(maxWidth: 150)
        }
        .padding()
        
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        AvailabilityView(available: 7, total: 10)
            .previewLayout(PreviewLayout.fixed(width: 272, height: 340))
            .background(Color.accentColor)
            .accentColor(.purple)

        
        AvailabilityView(available: 5, total: 10)
            .previewLayout(PreviewLayout.fixed(width: 272, height: 340))
            .preferredColorScheme(.dark)
            .background(Color.accentColor)

    }
}
