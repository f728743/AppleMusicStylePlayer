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
            let small = model.state == .paused
            KFImage.url(model.display.artwork)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .background(Color(UIColor.palette.playerCard.artworkBackground))
                .clipShape(RoundedRectangle(cornerRadius: expanded ? 10 : 5, style: .continuous))
                .padding(small ? 48 : 0)
                .shadow(
                    color: Color(.sRGBLinear, white: 0, opacity: small ? 0.13 : 0.33),
                    radius: small ? 3 : 8,
                    y: small ? 3 : 10
                )
                .frame(width: size.width, height: size.height)
                .animation(.smooth, value: model.state)
        }
    }
}

#Preview {
    @Previewable @State var model = PlayerController(
        playList: PlayListController(),
        player: Player()
    )

    ExpandedPlayer(
        expanded: .constant(true),
        size: UIScreen.main.bounds.size,
        safeArea: (UIApplication.keyWindow?.safeAreaInsets ?? .zero).edgeInsets,
        animationNamespace: Namespace().wrappedValue
    )
    .onAppear {
        model.onAppear()
    }
    .background {
        ColorfulBackground(
            colors: model.colors.map { Color($0.color) }
        )
        .overlay(Color(UIColor(white: 0.4, alpha: 0.5)))
    }
    .ignoresSafeArea()
    .environment(model)
}
