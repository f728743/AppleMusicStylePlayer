//
//  MediaListView.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 09.12.2024.
//

import Kingfisher
import SwiftUI

struct MediaListView: View {
    @Environment(PlayListController.self) var model
    @Environment(\.nowPlayingExpandProgress) var expandProgress

    var body: some View {
        NavigationStack {
            ScrollView {
                content
            }
            .contentMargins(.bottom, ViewConst.tabbarHeight + 27, for: .scrollContent)
            .contentMargins(.bottom, ViewConst.tabbarHeight, for: .scrollIndicators)
            .background(Color(.palette.appBackground(expandProgress: expandProgress)))
            .toolbar {
                Button {
                    print("Profile tapped")
                }
                label: {
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color(.palette.brand))
                }
            }
        }
    }
}

private extension MediaListView {
    var content: some View {
        VStack(spacing: 0) {
            header
                .padding(.horizontal, ViewConst.screenPaddings)
                .padding(.top, 7)
            buttons
                .padding(.horizontal, ViewConst.screenPaddings)
                .padding(.top, 14)
            list
                .padding(.top, 26)
            footer
                .padding(.top, 17)
        }
    }

    var header: some View {
        VStack(spacing: 0) {
            let border = UIScreen.hairlineWidth
            KFImage.url(model.display.artwork)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .background(Color(.palette.artworkBackground))
                .clipShape(.rect(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .inset(by: border / 2)
                        .stroke(Color(.palette.artworkBorder), lineWidth: border)
                )
                .padding(.horizontal, 52)

            Text(model.display.title)
                .font(.appFont.mediaListHeaderTitle)
                .padding(.top, 18)

            if let subtitle = model.display.subtitle {
                Text(subtitle)
                    .font(.appFont.mediaListHeaderSubtitle)
                    .foregroundStyle(Color(.palette.textSecondary))
                    .padding(.top, 2)
            }
        }
    }

    var buttons: some View {
        HStack(spacing: 16) {
            Button {
                print("Play")
            }
            label: {
                Label("Play", systemImage: "play.fill")
            }

            Button {
                print("Shuffle")
            }
            label: {
                Label("Shuffle", systemImage: "shuffle")
            }
        }
        .buttonStyle(AppleMusicButton())
        .font(.appFont.button)
    }

    var list: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(model.display.items.enumerated()), id: \.offset) { offset, item in
                VStack(spacing: 0) {
                    let isFirstItem = offset == 0
                    let isLastItem = offset == model.items.count - 1
                    if isFirstItem {
                        Divider()
                    }
                    MediaItemView(
                        artwork: item.artwork,
                        title: item.title,
                        subtitle: item.subtitle,
                        divider: isLastItem ? .long : .short
                    )
                }
                .padding(.leading, ViewConst.screenPaddings)
            }
        }
    }

    @ViewBuilder
    var footer: some View {
        if let text = model.footer {
            Text(text)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, ViewConst.screenPaddings)
                .foregroundStyle(Color(.palette.textTertiary))
                .font(.appFont.mediaListItemFooter)
        }
    }
}

struct AppleMusicButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: 48)
            .frame(maxWidth: .infinity)
            .background(Color(.palette.buttonBackground))
            .foregroundStyle(Color(.palette.brand))
            .clipShape(.rect(cornerRadius: 10))
            .opacity(configuration.isPressed ? 0.65 : 1)
    }
}

struct MediaItemView: View {
    enum DividerType {
        case short
        case long
    }

    let artwork: URL?
    let title: String
    let subtitle: String?
    let divider: DividerType

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                let border = UIScreen.hairlineWidth
                KFImage.url(artwork)
                    .resizable()
                    .frame(width: 48, height: 48)
                    .aspectRatio(contentMode: .fill)
                    .background(Color(.palette.artworkBackground))
                    .clipShape(.rect(cornerRadius: 5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .inset(by: border / 2)
                            .stroke(Color(.palette.artworkBorder), lineWidth: border)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.appFont.mediaListItemTitle)
                    Text(subtitle ?? "")
                        .font(.appFont.mediaListItemSubtitle)
                        .foregroundStyle(Color(.palette.textTertiary))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(1)
            }
            .padding(.top, 4)
            Spacer(minLength: 0)
            Divider()
                .padding(.leading, divider == .long ? 0 : 60)
        }
        .frame(height: 56)
    }
}

#Preview {
    MediaListView()
        .environment(PlayListController())
}
