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
            tint: .init(Palette.PlayerCard.transparent),
            pressedColor: .init(Palette.PlayerCard.translucent)
        )
    }
}

#Preview {
    ZStack(alignment: .top) {
        ColorfulBackground(
            colors: [
                UIColor(red: 0.3, green: 0.4, blue: 0.3, alpha: 1.0),
                UIColor(red: 0.4, green: 0.4, blue: 0.6, alpha: 1.0)
            ].map { Color($0) }
        )
        .ignoresSafeArea()

        VStack {
            Text("Header")
                .blendMode(.overlay)
            PlayerButtons(playerSize: UIScreen.main.bounds.size)
            Text("Footer")
                .blendMode(.overlay)
        }
        .foregroundColor(.init(Palette.PlayerCard.transparent))
    }

    .environment(
        PlayerController(
            playList: PlayListController(),
            player: Player()
        )
    )
}
