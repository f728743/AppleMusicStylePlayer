//
//  PlayerButtons.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 15.12.2024.
//

import SwiftUI

struct PlayerButtons: View {
    @Environment(PlayerController.self) var model
    let playerSize: CGSize

    var body: some View {
        HStack(spacing: playerSize.width * 0.14) {
            PlayerButton(
                model.backwardButton,
                config: .playerControls,
                onEnded: {
                    model.onBackward()
                }
            )

            PlayerButton(
                model.playPauseButton,
                config: .playerControls,
                onEnded: {
                    model.onPlayPause()
                }
            )

            PlayerButton(
                model.forwardButton,
                config: .playerControls,
                onEnded: {
                    model.onForward()
                }
            )
        }
        .foregroundColor(.white)
    }
}

extension PlayerButton.Config {
    static var playerControls: Self {
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
            PlayerButtons(playerSize: UIScreen.main.bounds.size)
            Text("Footer")
                .blendMode(.overlay)
        }
        .foregroundColor(.init(Palette.PlayerCard.opaque))
    }
    .environment(
        PlayerController(playList: PlayListController(), player: Player())
    )
}
