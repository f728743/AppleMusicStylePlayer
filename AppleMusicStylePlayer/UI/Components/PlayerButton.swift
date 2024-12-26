//
//  PlayerButton.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 18.12.2024.
//

import Combine
import SwiftUI

enum ButtonType {
    case play
    case stop
    case pause
    case backward
    case forward
}

struct PlayerButton: View {
    @Environment(\.isEnabled) private var isEnabled
    @State private var showCircle = false
    @State private var pressed = false
    private let type: ButtonType
    @Environment(\.playerButtonConfig) var config
    private let onPressed: (() -> Void)?
    private let onPressing: ((TimeInterval) -> Void)?
    private let onEnded: (() -> Void)?

    init(
        _ type: ButtonType,
        onPressed: (() -> Void)? = nil,
        onPressing: ((TimeInterval) -> Void)? = nil,
        onEnded: (() -> Void)? = nil
    ) {
        self.type = type
        self.onPressed = onPressed
        self.onPressing = onPressing
        self.onEnded = onEnded
    }

    var body: some View {
        Image(systemName: type.systemImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: config.imageSize, height: config.imageSize)
            .scaleEffect(pressed ? 0.9 : 1)
            .frame(width: config.circleSize, height: config.circleSize)
            .foregroundColor(color)
            .background(showCircle ? config.tint : .clear)
            .clipShape(Ellipse())
            .scaleEffect(pressed ? 0.85 : 1)
            .onPressGesture(
                interval: config.updateUnterval,
                onPressed: {
                    guard isEnabled else { return }
                    withAnimation {
                        showCircle = true
                        pressed = true
                    }
                    onPressed?()
                },
                onPressing: { time in
                    guard isEnabled else { return }
                    onPressing?(time)
                },
                onEnded: {
                    guard isEnabled else { return }
                    delay(0.2) {
                        withAnimation {
                            showCircle = false
                        }
                    }
                    withAnimation {
                        pressed = false
                    }
                    onEnded?()
                }
            )
            .contentTransition(.symbolEffect(.replace))
    }
}

private extension PlayerButton {
    var color: Color {
        isEnabled ? showCircle ? config.pressedColor : config.labelColor : config.disabledColor
    }
}

extension View {
    func playerButtonStyle(_ config: PlayerButtonConfig) -> some View {
        environment(\.playerButtonConfig, config)
    }
}

private struct PlayerButtonConfigEnvironmentKey: EnvironmentKey {
    static var defaultValue: PlayerButtonConfig = .init()
}

extension EnvironmentValues {
    var playerButtonConfig: PlayerButtonConfig {
        get { self[PlayerButtonConfigEnvironmentKey.self] }
        set { self[PlayerButtonConfigEnvironmentKey.self] = newValue }
    }
}

struct PlayerButtonConfig {
    let updateUnterval: TimeInterval
    let imageSize: CGFloat
    let circleSize: CGFloat
    let labelColor: Color
    let tint: Color
    let pressedColor: Color
    let disabledColor: Color

    init(
        updateUnterval: TimeInterval = 0.1,
        imageSize: CGFloat = 34,
        circleSize: CGFloat = 68,
        labelColor: Color = .init(UIColor.label),
        tint: Color = .init(UIColor.tintColor),
        pressedColor: Color = .init(UIColor.secondaryLabel),
        disabledColor: Color = .init(UIColor.secondaryLabel)
    ) {
        self.updateUnterval = updateUnterval
        self.imageSize = imageSize
        self.circleSize = circleSize
        self.labelColor = labelColor
        self.tint = tint
        self.pressedColor = pressedColor
        self.disabledColor = disabledColor
    }
}

extension ButtonType {
    var systemImage: String {
        switch self {
        case .play: "play.fill"
        case .stop: "stop.fill"
        case .pause: "pause.fill"
        case .backward: "backward.fill"
        case .forward: "forward.fill"
        }
    }
}

#Preview {
    HStack(spacing: 60) {
        VStack {
            PlayerButton(
                .play,
                onPressed: {
                    print("onPressed Button One")
                },
                onPressing: { time in
                    print("onPressing \(time) Button One")
                },
                onEnded: {
                    print("onEnded Button One")
                }
            )
            .disabled(true)
            Text("Disabled")
        }

        VStack {
            PlayerButton(
                .play,
                onPressed: {
                    print("onPressed Button Two")
                },
                onPressing: { time in
                    print("onPressing \(time) Button Two")
                },
                onEnded: {
                    print("onEnded Button Two")
                }
            )
            .disabled(false)
            Text("Enabled")
        }
    }
}
