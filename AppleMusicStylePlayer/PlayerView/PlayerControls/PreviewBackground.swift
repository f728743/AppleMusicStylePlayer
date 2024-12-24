//
//  PreviewBackground.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 25.12.2024.
//

import SwiftUI

struct PreviewBackground: View {
    var body: some View {
        ColorfulBackground(
            colors: [
                UIColor(red: 0.85, green: 0.7, blue: 0.6, alpha: 1.0),
                UIColor(red: 0.15, green: 0.3, blue: 0.2, alpha: 1.0)
            ].map { Color($0) }
        )
        .overlay(Color(UIColor(white: 0.4, alpha: 0.5)))
        .ignoresSafeArea()
    }
}

#Preview {
    struct ColorView: View {
        let uiColor: UIColor
        var body: some View {
            Color(uiColor)
                .frame(width: 60, height: 60)
        }
    }

    struct ColorsView: View {
        @State var white: CGFloat = 0.784
        @State var alpha: CGFloat = 0.816
        @State var hidden: Bool = false
        var body: some View {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    ColorView(uiColor: Palette.PlayerCard.opaque)
                    ZStack {
                        ColorView(uiColor: Palette.PlayerCard.translucent)
                        ColorView(uiColor: Palette.PlayerCard.translucent)
                    }
                    ColorView(uiColor: Palette.PlayerCard.translucent)
                }
                .blendMode(.overlay)
                .hidden(hidden)

                HStack(spacing: 0) {
                    ColorView(uiColor: Palette.PlayerCard.opaque)
                    ZStack {
                        ColorView(uiColor: color)
                        ColorView(uiColor: color)
                    }
                    ColorView(uiColor: color)
                }
                .blendMode(.overlay)

                var color: UIColor {
                    .init(white: white, alpha: alpha)
                }

                VStack(spacing: 30) {
                    Slider(value: $white, in: 0 ... 1)
                        .padding(.top, 10)
                    Slider(value: $alpha, in: 0 ... 1)

                    Text("White: \(white)")
                    Text("Alpha: \(alpha)")
                    Button("Hide") {
                        hidden.toggle()
                    }
                }
                .foregroundStyle(.white)
                .padding(60)
            }
        }
    }

    return ZStack {
        PreviewBackground()
        ColorsView()
    }
}
