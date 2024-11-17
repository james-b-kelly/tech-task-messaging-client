//
//  Style.swift
//  BlinkTechnicalTask
//
//  Created by Jamie Kelly on 10/11/2024.
//

import Foundation
import SwiftUI

// Pulled in and pared-down from a side project to help with styling/theming.
// Passed as an Environment object, this can be used really easily on any subview
// of the view it is declared on.
 
class Style: ObservableObject {
    
    init() {
        colors = Colors.standard()
        fonts = Fonts.standard()
        iconNames = IconNames.standard()
    }
    
    @Published var colors: Colors
    @Published var fonts: Fonts
    @Published var iconNames: IconNames
    
    struct Colors {
        static func standard() -> Colors {
            return Colors(
                brandPrimary: Color(hex: "7CA4F9"),
                background1: Color(hex: "FFFFFF"),
                background2: Color(hex: "F5F5F5"),
                backgroundContrast: Color(hex: "161616"),
                interactive: Color(hex: "7CA4F9"),
                destructive: Color(hex: "FF3B30"),
                alert: Color(hex: "FFCC00"),
                text: Color(hex: "000000"),
                textMeta: Color(hex: "A0A0A0"),
                outline: Color(hex: "444444"),
                separator: Color(hex: "121212")
            )
        }
        
        let brandPrimary: Color
        let background1: Color
        let background2: Color
        let backgroundContrast: Color
        
        
        let interactive: Color
        let destructive: Color
        let alert: Color
        let text: Color
        
        let textMeta: Color
        let outline: Color
        
        let separator: Color
        
    }
    
    struct Fonts {
        static func standard() -> Fonts {
            return Fonts(title: .system(size: 21, weight: .semibold),
                         subtitle: .system(size: 18, weight: .medium),
                         body: .system(size: 16, weight: .regular),
                         CTAIcon: .system(size: 26, weight: .semibold),
                         meta: .system(size: 14, weight: .regular))
        }
        let title: Font
        let subtitle: Font
        let body: Font
        let CTAIcon: Font
        let meta: Font
    }

    
    struct IconNames {
        static func standard() -> IconNames {
            return IconNames()
        }
        let plus: String = "plus"
    }

}

extension Image {
    
    enum IconSize {
        case small
        case regular
        case large
        case extraLarge
        
        var fontSize: CGFloat {
            switch self {
            case .small:
                return 12
            case .regular:
                return 16
            case .large:
                return 22
            case .extraLarge:
                return 44
            }
        }
    }
    
    func imageStyle(size: IconSize, color: Color) -> some View {
        self.foregroundColor(color)
            .font(.system(size: size.fontSize, weight: .semibold))
    }
                      
}

extension Color {
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
}
