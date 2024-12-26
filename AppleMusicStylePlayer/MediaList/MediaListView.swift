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
    @Environment(\.playerExpandProgress) var expandProgress

    var body: some View {
        ScrollView {
            content
                .padding(.horizontal, 20)
        }
        .background(Color(.palette.appBackground(expandProgress: expandProgress)))
    }
}

private extension MediaListView {
    var content: some View {
        VStack(alignment: .leading) {
            ForEach(Array(model.items.enumerated()), id: \.offset) { offset, item in
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
            }
        }
        .padding(.bottom, 70)
    }
}

struct MediaItemView: View {
    let artwork: URL?
    let title: String
    let subtitle: String?

    var body: some View {
        HStack(spacing: 12) {
            KFImage.url(artwork)
                .resizable()
                .frame(width: 48, height: 48)
                .aspectRatio(contentMode: .fill)
                .background(Color(UIColor.systemGray5))
                .clipShape(.rect(cornerRadius: 3))

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
