//
//  MiniPlayer.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 20.11.2024.
//

import Kingfisher
import SwiftUI

struct MiniPlayer: View {
    @Environment(PlayerController.self) var model
    @Binding var expanded: Bool
    var animationNamespace: Namespace.ID

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                if !expanded {
                    KFImage.url(model.display.artwork)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(.rect(cornerRadius: 10))
                        .matchedGeometryEffect(
                            id: PlayerMatchedGeometry.artwork,
                            in: animationNamespace
                        )
                }
            }
            .frame(width: 40, height: 40)

            Text(model.title)

            Spacer(minLength: 0)

            Group {
                Button("", systemImage: model.playPauseButton.systemImage) {
                    model.onPlayPause()
                }

                Button("", systemImage: "forward.fill") {
                    model.onForward()
                }
            }
            .font(.title3)
            .foregroundStyle(.primary)
        }
        .padding(.horizontal, 10)
        .frame(height: 55)
        .contentShape(.rect)
        .onTapGesture {
            withAnimation(.playerExpandAnimation) {
                expanded = true
            }
        }
    }
}

#Preview {
    MiniPlayer(
        expanded: .constant(false),
        animationNamespace: Namespace().wrappedValue
    )
    .environment(
        PlayerController(
            playList: PlayListController(),
            player: Player()
        )
    )
}
