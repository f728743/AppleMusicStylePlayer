//
//  PlayerControls.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 01.12.2024.
//

import SwiftUI

struct PlayerControls: View {
    @Environment(PlayerController.self) var model
    @State private var volume: CGFloat = 0.5

    var body: some View {
        GeometryReader {
            let size = $0.size
            let spacing = size.verticalSpacing
            VStack(spacing: spacing) {
                VStack(spacing: spacing) {
                    trackInfo
                    TimingIndicator(spacing: spacing)
                        .padding(.top, spacing)
                        .padding(.horizontal, ViewConst.playerCardPaddings)
                }
                .frame(height: size.height / 2.5, alignment: .top)
                PlayerButtons(playerSize: size)
                    .padding(.horizontal, ViewConst.playerCardPaddings)
                volume(playerSize: size)
                    .padding(.horizontal, ViewConst.playerCardPaddings)
            }
        }
    }
}

private extension CGSize {
    var verticalSpacing: CGFloat { height * 0.04 }
}

private extension PlayerControls {
    var palette: Palette.PlayerCard.Type {
        UIColor.palette.playerCard.self
    }

    var trackInfo: some View {
        HStack(alignment: .center, spacing: 15) {
            VStack(alignment: .leading, spacing: 4) {
                let fade = ViewConst.playerCardPaddings
                let cfg = MarqueeText.Config(leftFade: fade, rightFade: fade)
                MarqueeText(model.display.title, config: cfg)
                    .transformEffect(.identity)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(palette.opaque))
                MarqueeText(model.display.subtitle ?? "", config: cfg)
                    .transformEffect(.identity)
                    .foregroundColor(Color(palette.translucent))
                    .blendMode(.overlay)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    func volume(playerSize: CGSize) -> some View {
        VStack(spacing: playerSize.verticalSpacing) {
            HStack(spacing: 15) {
                Image(systemName: "speaker.fill")
                    .blendMode(.overlay)
                RubberSlider(
                    value: $volume,
                    in: 0 ... 1,
                    config: .playerControls
                )
                .transformEffect(.identity)
                Image(systemName: "speaker.wave.3.fill")
                    .blendMode(.overlay)
            }
            .foregroundColor(Color(palette.translucent))

            footer(width: playerSize.width)
                .padding(.top, playerSize.verticalSpacing)
        }
        .frame(height: playerSize.height / 2.5, alignment: .bottom)
    }

    func footer(width: CGFloat) -> some View {
        HStack(alignment: .top, spacing: width * 0.18) {
            Button {} label: {
                Image(systemName: "quote.bubble")
                    .font(.title2)
            }
            VStack(spacing: 6) {
                Button {} label: {
                    Image(systemName: "airpods.gen3")
                        .font(.title2)
                }
                Text("iPhone's Airpods")
                    .font(.caption)
            }
            Button {} label: {
                Image(systemName: "list.bullet")
                    .font(.title2)
            }
        }
        .foregroundColor(Color(palette.translucent))
        .blendMode(.overlay)
    }
}

#Preview {
    ZStack(alignment: .bottom) {
        ColorfulBackground(
            colors: [
                UIColor(red: 0.3, green: 0.4, blue: 0.3, alpha: 1.0),
                UIColor(red: 0.4, green: 0.4, blue: 0.6, alpha: 1.0)
            ].map { Color($0) }
        )
        .ignoresSafeArea()

        PlayerControls()
            .frame(height: 400)
    }

    .environment(
        PlayerController(
            playList: PlayListController(),
            player: Player()
        )
    )
}
