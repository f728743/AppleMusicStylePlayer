//
//  FontStyle.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 26.12.2024.
//

import SwiftUI

enum FontStyle {
    case timingIndicator
    case miniPlayerTitle
    case button
    case mediaListHeaderTitle
    case mediaListHeaderSubtitle
    case tabbar
}

struct Typography {
    let font: Font
    let kerning: CGFloat
}

extension FontStyle {
    var typography: Typography {
        switch self {
        case .timingIndicator:
            Typography(
                font: .system(size: 12, weight: .semibold),
                kerning: 0
            )
        
        case .miniPlayerTitle:
            Typography(
                font: .system(size: 15, weight: .regular),
                kerning: 0.11
            )
            
        case .button:
            Typography(
                font: .system(size: 17, weight: .semibold),
                kerning: 0
            )

        case .mediaListHeaderTitle:
            Typography(
                font: .system(size: 20, weight: .semibold),
                kerning: 0
            )

        case .mediaListHeaderSubtitle:
            Typography(
                font: .system(size: 20, weight: .regular),
                kerning: 0
            )
            
        case .tabbar:
            Typography(
                font: .system(size: 10, weight: .regular),
                kerning: 0
            )
        }
    }
}

extension View {
    func text(style: FontStyle) -> some View {
        let typography = style.typography
        return font(typography.font)
            .kerning(typography.kerning)
    }
}
