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
            .contentMargins(.bottom, ViewConst.tabbarHeight, for: .scrollContent)
            .contentMargins(.bottom, ViewConst.tabbarHeight, for: .scrollIndicators)
            .background(Color(.palette.appBackground(expandProgress: expandProgress)))
            .toolbar {
                Button {
                    print("Profile tapped!")
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
                        .inset(by: border/2)
                        .stroke(Color(.palette.artworkBorder), lineWidth: border)
                )
                .padding(.horizontal, 52)
            
            Text(model.display.title)
                .text(style: .mediaListHeaderTitle)
                .padding(.top, 18)
            
            if let subtitle = model.display.subtitle {
                Text(subtitle)
                    .text(style: .mediaListHeaderSubtitle)
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
        .text(style: .button)
    }
    
    var list: some View {
        VStack(alignment: .leading) {
            ForEach(Array(model.display.items.enumerated()), id: \.offset) { offset, item in
                VStack(spacing: 4) {
                    let isFirstItem = offset == 0
                    let isLastItem = offset == model.items.count - 1
                    if isFirstItem {
                        Divider()
                    }
                    MediaItemView(
                        artwork: item.artwork,
                        title: item.title,
                        subtitle: item.subtitle
                    )
                    Divider()
                        .padding(.leading, isLastItem ? 0 : 60)
                }
                .padding(.leading, ViewConst.screenPaddings)
            }
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
    let artwork: URL?
    let title: String
    let subtitle: String?

    var body: some View {
        HStack(spacing: 12) {
            let border = UIScreen.hairlineWidth
            KFImage.url(artwork)
                .resizable()
                .frame(width: 48, height: 48)
                .aspectRatio(contentMode: .fill)
                .background(Color(.palette.artworkBackground))
                .clipShape(.rect(cornerRadius: 3))
                .overlay(
                    RoundedRectangle(cornerRadius: 3)
                        .inset(by: border/2)
                        .stroke(Color(.palette.artworkBorder), lineWidth: border)
                )

            VStack(alignment: .leading) {
                Text(title)
                Text(subtitle ?? "")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineLimit(1)
        }
    }
}

#Preview {
    MediaListView()
        .environment(PlayListController())
}
