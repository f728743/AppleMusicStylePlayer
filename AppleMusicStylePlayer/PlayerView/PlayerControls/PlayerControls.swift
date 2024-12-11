//
//  PlayerControls.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 01.12.2024.
//

import SwiftUI

struct PlayerControls: View {
    @Environment(PlayerController.self) var model
    @State private var speed = 50.0
    @State private var isEditing = false
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
                controls(playerSize: size)
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

extension View {
    func animationsDisabled(_ disabled: Bool) -> some View {
        transaction { (tx: inout Transaction) in
            tx.animation = tx.animation
            tx.disablesAnimations = disabled
        }
    }
}

private extension PlayerControls {
    var  palette: Palette.PlayerCard.Type {
        UIColor.palette.playerCard.self
    }

    var trackInfo: some View {
        HStack(alignment: .center, spacing: 15) {
            VStack(alignment: .leading, spacing: 4) {
                let fade = ViewConst.playerCardPaddings
                MarqueeText(model.display.title, leftFade: fade, rightFade: fade)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(palette.opaque))
                MarqueeText(model.display.subtitle ?? "", leftFade: fade, rightFade: fade)
                    .foregroundColor(Color(palette.translucent))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    func controls(playerSize: CGSize) -> some View {
        HStack(spacing: playerSize.width * 0.18) {
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
        .frame(maxHeight: .infinity)
    }

    func volume(playerSize: CGSize) -> some View {
        VStack(spacing: playerSize.verticalSpacing) {
            HStack(spacing: 15) {
                Image(systemName: "speaker.fill")
                Capsule()
                    .fill(.ultraThinMaterial)
                    .environment(\.colorScheme, .light)
                    .frame(height: 5)
                Image(systemName: "speaker.wave.3.fill")
            }
            .foregroundColor(.gray)

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
    }
}

struct TimingIndicator: View {
    let spacing: CGFloat
    var body: some View {
        VStack(spacing: spacing) {
            Capsule()
                .fill(.ultraThinMaterial)
                .environment(\.colorScheme, .light)
                .frame(height: 5)
            HStack {
                Text("0:00")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer(minLength: 0)
                Text("3:33")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    ZStack {
        Color(UIColor.gray)
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

extension UIColor {
    static let myControlBackground: UIColor = dynamic(
        light: UIColor(red: 0.3, green: 0.4, blue: 0.5, alpha: 1),
        dark: UIColor(red: 0.4, green: 0.3, blue: 0.2, alpha: 1)
    )
}
