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
            Button(
                action: { model.onBackward() },
                label: {
                    Image(systemName: "backward.fill")
                        .font(playerSize.height < 300 ? .title3 : .title)
                }
            )

            Button(
                action: { model.onPlayPause() },
                label: {
                    Image(systemName: model.playPauseIcon.systemImage)
                        .font(playerSize.height < 300 ? .largeTitle : .system(size: 50))
                }
            )

            Button(
                action: { model.onForward() },
                label: {
                    Image(systemName: "forward.fill")
                        .font(playerSize.height < 300 ? .title3 : .title)
                }
            )
        }
        .foregroundColor(.white)
    }
}

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .aspectRatio(contentMode: .fit)
            .frame(width: 44, height: 44)
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
            .frame(width: 60, height: 60)
            .background(.blue.opacity(configuration.isPressed ? 0.5 : 0))
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
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
            PlayerButtons(playerSize: UIScreen.main.bounds.size)
            Text("Footer")
        }
    }

    .environment(
        PlayerController(
            playList: PlayListController(),
            player: Player()
        )
    )
}
