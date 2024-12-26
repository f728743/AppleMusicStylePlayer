//
//  PlayerButtons.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 15.12.2024.
//

import SwiftUI

struct PlayerButtons: View {
    @Environment(PlayerController.self) var model
    let spacing: CGFloat

    var body: some View {
        HStack(spacing: spacing) {
            PlayerButton(
                model.backwardButton,
                onEnded: {
                    model.onBackward()
                }
            )

            PlayerButton(
                model.playPauseButton,
                onEnded: {
                    model.onPlayPause()
                }
            )

            PlayerButton(
                model.forwardButton,
                onEnded: {
                    model.onForward()
                }
            )
        }
        .playerButtonStyle(.expandedPlayer)
        .foregroundColor(.white)
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
        PlayerController(playList: PlayListController(), player: Player())
    )
}
