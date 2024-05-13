//
//  TextFieldModifier.swift
//  AuthModule
//
//  Created by Polina on 13.05.2024.
//

import SwiftUI

struct TextFieldModifier: ViewModifier {
    let roundCorners: CGFloat
    let gradientFirstColor: Color
    let gradientSecondColor: Color

    func body(content: Content) -> some View {
        content
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [gradientFirstColor, gradientSecondColor]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(roundCorners)
            .padding(3)
            .overlay(RoundedRectangle(cornerRadius: roundCorners)
                .stroke(LinearGradient(gradient: Gradient(colors: [gradientFirstColor, gradientSecondColor]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2))
            .tint(.gray)
    }
}
