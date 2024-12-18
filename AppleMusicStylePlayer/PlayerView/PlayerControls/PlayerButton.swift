//
//  PlayerButton.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 18.12.2024.
//

import Combine
import SwiftUI

struct PlayerButton: View {
    @Environment(\.isEnabled) private var isEnabled
    @State private var showCircle = false
    @State private var pressed = false
    private let systemName: String
    private var config: Config

    init(
        systemName: String = "play.fill",
        config: Config = .init()
    ) {
        self.systemName = systemName
        self.config = config
    }

    var body: some View {
        Image(systemName: systemName)
            .resizable()
            .frame(width: config.imageSize, height: config.imageSize)
            .scaleEffect(pressed ? 0.9 : 1)
            .frame(width: config.circleSize, height: config.circleSize)
            .foregroundColor(color)
            .background(showCircle ? config.tint : .clear)
            .clipShape(Ellipse())
            .scaleEffect(pressed ? 0.85 : 1)
            .onPressGesture(
                interval: 0.1,
                onPressed: {
                    guard isEnabled else { return }
                    withAnimation {
                        showCircle = true
                        pressed = true
                    }
                    print("onPressed")
                },
                onPressing: { time in
                    guard isEnabled else { return }
                    print("onPressing \(time)")
                },
                onEnded: {
                    guard isEnabled else { return }
                    withAnimation(.default.delay(0.1)) {
                        showCircle = false
                    }
                    withAnimation {
                        pressed = false
                    }
                    print("onEnded")
                }
            )
    }

    struct Config {
        var imageSize: CGFloat = 34
        var circleSize: CGFloat = 68
        var labelColor: Color = .init(UIColor.label)
        var tint: Color = .init(UIColor.tintColor)
        var pressedColor: Color = .init(UIColor.secondaryLabel)
        var disabledColor: Color = .init(UIColor.secondaryLabel)
    }
}

private extension PlayerButton {
    var color: Color {
        isEnabled ? showCircle ? config.pressedColor : config.labelColor : config.disabledColor
    }
}

#Preview {
    HStack(spacing: 60) {
        VStack {
            PlayerButton()
                .disabled(true)
            Text("Disabled")
        }

        VStack {
            PlayerButton()
                .disabled(false)
            Text("Enabled")
        }

    }
}
