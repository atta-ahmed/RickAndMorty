//
//  Extensions.swift
//  RickAndMorty
//
//  Created by Atta ElAshmawy, Vodafone on 16/10/2024.
//

import Foundation

import SwiftUI


fileprivate struct ModifierCornerRadiusWithBorder: ViewModifier {
    var radius: CGFloat
    var borderLineWidth: CGFloat = 1
    var borderColor: Color = .gray
    var antialiased: Bool = true
    
    func body(content: Content) -> some View {
        content
            .cornerRadius(self.radius, antialiased: self.antialiased)
            .overlay(
                RoundedRectangle(cornerRadius: self.radius)
                    .inset(by: self.borderLineWidth)
                    .strokeBorder(self.borderColor, lineWidth: self.borderLineWidth, antialiased: self.antialiased)
            )
    }
}

extension View {
    func border(_ borderColor: Color = .gray, width: CGFloat = 1, cornerRadius: CGFloat, antialiased: Bool = true) -> some View {
        modifier(ModifierCornerRadiusWithBorder(radius: cornerRadius, borderLineWidth: width, borderColor: borderColor, antialiased: antialiased))
    }
}

fileprivate struct BackgroundWithCornerRadius: ViewModifier {
    var backgroundColor: Color
    var cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
    }
}

extension View {
    func background(_ backgroundColor: Color, cornerRadius: CGFloat) -> some View {
        self.modifier(BackgroundWithCornerRadius(backgroundColor: backgroundColor, cornerRadius: cornerRadius))
    }
}

extension UIColor {
    public static let primaryAppColor = #colorLiteral(red: 0.9333333333, green: 0.1294117647, blue: 0.1803921569, alpha: 1)
    public static let borderGrayColor = #colorLiteral(red: 0.9198423028, green: 0.9198423028, blue: 0.9198423028, alpha: 1)
}

