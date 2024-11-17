//
//  ButtonStyles.swift
//  MessagingClient
//
//  Created by Jamie Kelly on 10/11/2024.
//
import SwiftUI

struct AddMessageButtonStyle: ButtonStyle {
    @EnvironmentObject var style: Style
        
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 50, height: 50)
            .padding(.vertical, 7)
            .font(style.fonts.CTAIcon)
            .background(style.colors.background1)
            .foregroundColor(style.colors.interactive)
            .cornerRadius(4)
            .opacity(opacity(configuration))
            .overlay(
                RoundedRectangle(cornerRadius: 4).stroke(style.colors.interactive, lineWidth: 1.5)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
    
    //We have an object called Environment in our codebase, so we have to namespace SwiftUI's Environment directive.
    @SwiftUI.Environment(\.isEnabled) private var isEnabled: Bool
    
    func opacity(_ configuration: Configuration) -> CGFloat {
        if configuration.isPressed || !isEnabled {
            return 0.5
        }
        return 1.0
    }
        
}
