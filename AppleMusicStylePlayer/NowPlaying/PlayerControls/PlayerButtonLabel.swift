//
//  PlayerButtonLabel.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 28.12.2024.
//

import SwiftUI

enum ButtonType {
    case play
    case stop
    case pause
    case backward
    case forward
}

enum PlayerButtonTrigger: Equatable {
    case one(bouncing: Bool)
    case another(bouncing: Bool)
}

struct PlayerButtonLabel: View {
    let type: ButtonType
    let size: CGFloat
    var animationTrigger: PlayerButtonTrigger

    init(type: ButtonType, size: CGFloat, animationTrigger: PlayerButtonTrigger? = nil) {
        self.type = type
        self.size = size
        self.animationTrigger = animationTrigger ?? .one(bouncing: false)
    }

    var body: some View {
        switch type {
        case .forward:
            AnimatedForwardLabel(size: size, trigger: animationTrigger)
        case .backward:
            AnimatedForwardLabel(size: size, trigger: animationTrigger)
                .scaleEffect(x: -1)
        default:
            Image(systemName: type.systemImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: size)
        }
    }
}

extension PlayerButtonTrigger {
    mutating func toggle(bouncing: Bool) {
        switch self {
        case .one: self = .another(bouncing: bouncing)
        case .another: self = .one(bouncing: bouncing)
        }
    }
}

extension ButtonType {
    var systemImageName: String {
        switch self {
        case .play: "play.fill"
        case .stop: "stop.fill"
        case .pause: "pause.fill"
        case .backward: "backward.fill"
        case .forward: "forward.fill"
        }
    }
}

private struct Label: View {
    let size: CGFloat
    var progress: Double
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                gliph
                    .frame(maxWidth: lerp(0.5, size / 2, progress))
                    .opacity(lerp(0.1, 0.9, progress))
                gliph
                gliph
                    .frame(maxWidth: lerp(size / 2, 0.5, progress))
                    .opacity(lerp(1, 0.1, progress))
            }
        }
        .frame(width: size, height: size)
    }

    var gliph: some View {
        Image(systemName: "play.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

#Preview {
    @Previewable @State var trigger: PlayerButtonTrigger = .one(bouncing: true)
    VStack(spacing: 16) {
        PlayerButtonLabel(type: .play, size: 50)
        PlayerButtonLabel(type: .backward, size: 50, animationTrigger: trigger)
        PlayerButtonLabel(type: .forward, size: 50, animationTrigger: trigger)
        Button("Animate") {
            trigger.toggle(bouncing: true)
        }
    }
}
