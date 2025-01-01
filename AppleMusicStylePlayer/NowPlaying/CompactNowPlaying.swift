//
//  CompactNowPlaying.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 20.11.2024.
//

import Kingfisher
import SwiftUI

struct CompactNowPlaying: View {
    @Environment(NowPlayingController.self) var model
    @Binding var expanded: Bool
    var animationNamespace: Namespace.ID
    @State var forwardAnimationTrigger: PlayerButtonTrigger = .one(bouncing: false)

    var body: some View {
        HStack(spacing: 8) {
            artwork
                .frame(width: 40, height: 40)

            Text(model.title)
                .lineLimit(1)
                .text(style: .miniPlayerTitle)
                .padding(.trailing, -18)

            Spacer(minLength: 0)

            PlayerButton(
                label: {
                    PlayerButtonLabel(type: model.playPauseButton, size: 20)
                },
                onEnded: {
                    model.onPlayPause()
                }
            )
            .playerButtonStyle(.miniPlayer)

            PlayerButton(
                label: {
                    PlayerButtonLabel(
                        type: model.forwardButton,
                        size: 30,
                        animationTrigger: forwardAnimationTrigger
                    )
                },
                onEnded: {
                    model.onForward()
                    forwardAnimationTrigger.toggle(bouncing: true)
                }
            )
            .playerButtonStyle(.miniPlayer)
        }

        .padding(.horizontal, 8)
        .frame(height: 56)
        .contentShape(.rect)
        .transformEffect(.identity)
        .onTapGesture {
            withAnimation(.playerExpandAnimation) {
                expanded = true
            }
        }
    }
}

private extension CompactNowPlaying {
    @ViewBuilder
    var artwork: some View {
        if !expanded {
            KFImage.url(model.display.artwork)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .background(Color(UIColor.systemGray4))
                .clipShape(.rect(cornerRadius: 7))
                .matchedGeometryEffect(
                    id: PlayerMatchedGeometry.artwork,
                    in: animationNamespace
                )
        }
    }
}

extension PlayerButtonConfig {
    static var miniPlayer: Self {
        Self(
            size: 44,
            tint: .init(Palette.PlayerCard.translucent.withAlphaComponent(0.3))
        )
    }
}

#Preview {
    CompactNowPlaying(
        expanded: .constant(false),
        animationNamespace: Namespace().wrappedValue
    )
    .background(.gray)
    .environment(
        NowPlayingController(
            playList: PlayListController(),
            player: Player()
        )
    )
}
