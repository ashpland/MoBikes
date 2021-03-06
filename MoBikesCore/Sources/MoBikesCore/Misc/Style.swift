import SwiftUI
import UIKit

extension UIColor {
    var asColor: Color {
        Color(self)
    }
}

enum Style {
    enum Color {
        static let primary = #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1).asColor
        static let secondary = #colorLiteral(red: 0.3018391927, green: 0.6276475694, blue: 1, alpha: 1).asColor
        static let lightPrimary = #colorLiteral(red: 0.7806914647, green: 0.5464840253, blue: 0.7773131953, alpha: 1).asColor
        static let inactive = #colorLiteral(red: 0.754, green: 0.7540867925, blue: 0.754, alpha: 1).asColor
        static let border = #colorLiteral(red: 0.75, green: 0.75, blue: 0.75, alpha: 0.5039865154).asColor

        static let marker = (normal: Color.primary,
                             low: Color.lightPrimary)
    }
}

extension Color {
    static var Mo: Style.Color.Type { Style.Color.self }
}
