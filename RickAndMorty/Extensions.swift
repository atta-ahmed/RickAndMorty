//
//  Extensions.swift
//  RickAndMorty
//
//  Created by Atta ElAshmawy on 16/10/2024.
//

import Foundation

import SwiftUI

extension UIImageView {
    func loadImage(from url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}

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

extension Color {
    static let borderGrayColor = Color(red: 0.919, green: 0.919, blue: 0.919)
    static let aliveBGColor = Color(red: 0.917, green: 0.965, blue: 0.991)
    static let deadBGColor = Color(red: 1.0, green: 0.902, blue: 0.921)
    static let blueBGColor = Color(red: 0.0118, green: 0.729, blue: 0.988)
}

