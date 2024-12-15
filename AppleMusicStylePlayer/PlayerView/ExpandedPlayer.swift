//
//  ExpandedPlayer.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 20.11.2024.
//

import Kingfisher
import SwiftUI

struct ExpandedPlayer: View {
    @Environment(PlayerController.self) var model
    @Binding var expanded: Bool
    var size: CGSize
    var safeArea: EdgeInsets
    var animationNamespace: Namespace.ID

    var body: some View {
        VStack(spacing: 12) {
            grip
                .blendMode(.overlay)
                .opacity(expanded ? 1 : 0)

            if expanded {
                artwork
                    .matchedGeometryEffect(
                        id: PlayerMatchedGeometry.artwork,
                        in: animationNamespace
                    )
                    .frame(height: size.width - Const.horizontalPadding * 2)
                    .padding(.vertical, size.height < 700 ? 10 : 30)
                    .padding(.horizontal, 25)

                PlayerControls()
                    .transition(.move(edge: .bottom))
            }
        }
        .padding(.top, safeArea.top)
        .padding(.bottom, safeArea.bottom)
    }
}

private extension ExpandedPlayer {
    enum Const {
        static let horizontalPadding: CGFloat = 25
    }

    var grip: some View {
        Capsule()
            .fill(.white.secondary)
            .frame(width: 40, height: 5)
    }

    var artwork: some View {
        GeometryReader {
            let size = $0.size
            KFImage.url(model.display.artwork)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .clipShape(RoundedRectangle(cornerRadius: expanded ? 15 : 5, style: .continuous))
        }
    }
}

#Preview {
    ExpandedPlayer(
        expanded: .constant(true),
        size: UIScreen.main.bounds.size,
        safeArea: (UIApplication.keyWindow?.safeAreaInsets ?? .zero).edgeInsets,
        animationNamespace: Namespace().wrappedValue
    )
    .background {
        ColorfulBackground(
            colors: [
                UIColor(red: 0.3, green: 0.4, blue: 0.3, alpha: 1.0),
                UIColor(red: 0.4, green: 0.4, blue: 0.6, alpha: 1.0)
            ].map { Color($0) }
        )
    }
    .ignoresSafeArea()
    .environment(
        PlayerController(
            playList: PlayListController(),
            player: Player()
        )
    )
}
