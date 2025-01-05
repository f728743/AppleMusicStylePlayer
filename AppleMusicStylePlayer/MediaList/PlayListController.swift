//
//  PlayListController.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 30.11.2024.
//

import Observation

@Observable
class PlayListController {
    var library = MediaLibrary()
    var current: MediaList?

    init() {
        selectFirstAvailable()
    }

    var display: MediaList {
        current ?? .placeholder
    }

    var items: [Media] {
        current?.items ?? []
    }

    func selectFirstAvailable() {
        current = library.list.first { !$0.items.isEmpty }
    }
}

private extension MediaList {
    static var placeholder: Self {
        MediaList(
            artwork: nil,
            title: "---",
            subtitle: nil,
            items: []
        )
    }
}
