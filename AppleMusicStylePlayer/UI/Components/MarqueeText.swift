//
//  MarqueeText.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 03.12.2024.
//

import SwiftUI

struct MarqueeText: View {
    let text: String
    let startDelay: Double
    let alignment: Alignment
    let leftFade: CGFloat
    let rightFade: CGFloat
    let spacing: CGFloat

    @State private var textSize: CGSize = .zero
    @State private var animate = false

    init(
        _ text: String,
        startDelay: Double = 1.0,
        alignment: Alignment? = nil,
        leftFade: CGFloat = 40,
        rightFade: CGFloat = 40,
        spacing: CGFloat = 100
    ) {
        self.text = text
        self.startDelay = startDelay
        self.alignment = alignment ?? .topLeading
        self.leftFade = leftFade
        self.rightFade = rightFade
        self.spacing = spacing
    }

    var body: some View {
        GeometryReader { geo in
            let viewWidth =  geo.size.width
            let animatedTextVisible =  textSize.width > viewWidth
            ZStack {
                AnimatedText(
                    text: text,
                    viewWidth: viewWidth,
                    textSize: textSize,
                    leftFade: leftFade,
                    rightFade: rightFade,
                    spacing: spacing,
                    value: animate ? 1 : 0
                )
                .hidden(!animatedTextVisible)

                staticText
                    .hidden(animatedTextVisible)
            }
        }
        .frame(height: textSize.height)
        .overlay {
            Text(text)
                .padding(.leading, leftFade)
                .padding(.trailing, rightFade)
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
}

private extension MarqueeText {
    var staticText: some View {
        Text(text)
            .padding(.leading, leftFade)
            .padding(.trailing, rightFade)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: alignment)
    }

    var animation: Animation {
        .linear(duration: Double(textSize.width) / 30)
        .delay(startDelay)
        .repeatForever(autoreverses: false)
    }
}

private struct AnimatedText: View, Animatable {
    let text: String
    let viewWidth: CGFloat
    let textSize: CGSize
    let leftFade: CGFloat
    let rightFade: CGFloat
    let spacing: CGFloat

    var value: Double

    var animatableData: Double {
        get { value }
        set { value = newValue }
    }
    var body: some View {
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
        .offset(x: leftFade)
        .mask(fadeMask)
    }

    var lineWidth: CGFloat { textSize.width - (leftFade + rightFade) + spacing}
    var offset: Double { value * lineWidth }

    var fadeMask: some View {
        HStack(spacing: 0) {
            LinearGradient(
                gradient: Gradient(colors: [.black.opacity(0), .black]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: leftFade)
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
            .frame(width: rightFade)
        }
        .padding(.horizontal, 6)
    }
}

#Preview {
    HStack {
        MarqueeText(
            "A text that is way too long, but it scrolls",
            startDelay: 3,
            leftFade: 32,
            rightFade: 32
        )
        .background(.pink.opacity(0.6))

        Text("Normal Text")
            .background(.mint.opacity(0.6))
    }
    .padding(.horizontal, 16)
    .font(.largeTitle)
}
