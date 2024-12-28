//
//  PlayerButtons.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 15.12.2024.
//

import SwiftUI

struct PlayerButtons: View {
    @Environment(NowPlayingController.self) var model
    let spacing: CGFloat
    let imageSize: CGFloat = 34
    @State var backwardAnimationTrigger: PlayerButtonTrigger = .one(bouncing: false)
    @State var forwardAnimationTrigger: PlayerButtonTrigger = .one(bouncing: false)

    var body: some View {
        HStack(spacing: spacing) {
            PlayerButton(
                label: {
                    PlayerButtonLabel(
                        type: model.backwardButton,
                        size: imageSize,
                        animationTrigger: backwardAnimationTrigger
                    )
                },
                onEnded: {
                    backwardAnimationTrigger.toggle(bouncing: true)
                    model.onBackward()
                }
            )

            PlayerButton(
                label: {
                    PlayerButtonLabel(type: model.playPauseButton, size: imageSize)
                },
                onEnded: {
                    model.onPlayPause()
                }
            )

            PlayerButton(
                label: {
                    PlayerButtonLabel(
                        type: model.forwardButton,
                        size: imageSize,
                        animationTrigger: forwardAnimationTrigger
                    )
                },
                onEnded: {
                    forwardAnimationTrigger.toggle(bouncing: true)
                    model.onForward()
                }
            )
        }
        .playerButtonStyle(.expandedPlayer)
    }
}

extension PlayerButtonConfig {
    static var expandedPlayer: Self {
        Self(
            labelColor: .init(Palette.PlayerCard.opaque),
            tint: .init(Palette.PlayerCard.translucent.withAlphaComponent(0.3)),
            pressedColor: .init(Palette.PlayerCard.opaque)
        )
    }
}

#Preview {
    ZStack(alignment: .top) {
        PreviewBackground()
        VStack {
            Text("Header")
                .blendMode(.overlay)
            PlayerButtons(spacing: UIScreen.main.bounds.size.width * 0.14)
            Text("Footer")
                .blendMode(.overlay)
        }
        .foregroundColor(.init(Palette.PlayerCard.opaque))
    }
    .environment(
        NowPlayingController(playList: PlayListController(), player: Player())
    )
}
