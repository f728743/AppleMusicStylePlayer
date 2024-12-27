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
