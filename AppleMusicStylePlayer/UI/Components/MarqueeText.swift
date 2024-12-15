//
//  MarqueeText.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 03.12.2024.
//

import SwiftUI

struct MarqueeText: View {
    let text: String
    private var config: Config

    @State private var textSize: CGSize = .zero
    @State private var animate = false

    init(_ text: String, config: Config = .init()) {
        self.text = text
        self.config = config
    }

    var body: some View {
        GeometryReader { geo in
            let viewWidth = geo.size.width
            let animatedTextVisible = textSize.width > viewWidth
            ZStack {
                animatedText(viewWidth: viewWidth)
                    .hidden(!animatedTextVisible)

                staticText
                    .hidden(animatedTextVisible)
            }
        }
        .frame(height: textSize.height)
        .overlay {
            Text(text)
                .padding(.leading, config.leftFade)
                .padding(.trailing, config.rightFade)
                .lineLimit(1)
                .fixedSize()
                .measureSize { textSize = $0 }
                .hidden()
        }
        .onAppear {
            withAnimation(animation) {
                animate = true
            }
        }
    }

    struct Config {
        var startDelay: Double = 1.0
        var alignment: Alignment = .leading
        var leftFade: CGFloat = 40
        var rightFade: CGFloat = 40
        var spacing: CGFloat = 100
    }
}

private extension MarqueeText {
    func animatedText(viewWidth: CGFloat) -> some View {
        Group {
            Text(text)
                .offset(x: -offset)
            Text(text)
                .offset(x: -offset + lineWidth)
        }
        .lineLimit(1)
        .fixedSize(horizontal: true, vertical: false)
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .frame(width: viewWidth)
        .offset(x: config.leftFade)
        .mask(fadeMask)
    }

    var lineWidth: CGFloat { textSize.width - (config.leftFade + config.rightFade) + config.spacing }
    var offset: Double { animate ? lineWidth : 0 }

    var staticText: some View {
        Text(text)
            .padding(.leading, config.leftFade)
            .padding(.trailing, config.rightFade)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: config.alignment)
    }

    var animation: Animation {
        .linear(duration: Double(textSize.width) / 30)
            .delay(config.startDelay)
            .repeatForever(autoreverses: false)
    }

    var fadeMask: some View {
        HStack(spacing: 0) {
            LinearGradient(
                gradient: Gradient(colors: [.black.opacity(0), .black]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: config.leftFade)
            LinearGradient(
                gradient: Gradient(colors: [.black, .black]),
                startPoint: .leading,
                endPoint: .trailing
            )
            LinearGradient(
                gradient: Gradient(colors: [.black, .black.opacity(0)]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: config.rightFade)
        }
        .padding(.horizontal, 6)
    }
}

#Preview {
    HStack {
        MarqueeText(
            "A text that is way too long, but it scrolls",
            config: .init(
                startDelay: 3,
                leftFade: 32,
                rightFade: 32
            )
        )
        .background(.pink.opacity(0.6))

        Text("Normal Text")
            .background(.mint.opacity(0.6))
    }
    .padding(.horizontal, 16)
    .font(.largeTitle)
}
