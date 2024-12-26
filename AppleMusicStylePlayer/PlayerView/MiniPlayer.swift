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
        HStack(spacing: 8) {
            artwork
                .frame(width: 40, height: 40)
            
            Text(model.title)
                .lineLimit(1)
                .text(style: .miniPlayerTitle)
                .padding(.trailing, -18)
            
            Spacer(minLength: 0)

                PlayerButton(
                    model.playPauseButton,
                    onEnded: {
                        model.onPlayPause()
                    }
                )
                .playerButtonStyle(.miniPlayer(imageSize: 20))
                
                PlayerButton(
                    model.forwardButton,
                    onEnded: {
                        model.onForward()
                    }
                )
                .playerButtonStyle(.miniPlayer(imageSize: 30))
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

private extension MiniPlayer {
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
    static func miniPlayer(imageSize: CGFloat) -> Self {
        Self(
            imageSize: imageSize,
            circleSize: 44,
            tint: .init(Palette.PlayerCard.translucent.withAlphaComponent(0.3))
        )
    }
}

#Preview {
    MiniPlayer(
        expanded: .constant(false),
        animationNamespace: Namespace().wrappedValue
    )
    .background(.gray)
    .environment(
        PlayerController(
            playList: PlayListController(),
            player: Player()
        )
    )
}
