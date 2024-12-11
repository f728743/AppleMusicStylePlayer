//
//  MediaLibrary.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 27.11.2024.
//

import Foundation

final class MediaLibrary {
    var list: [MediaList]

    init() {
        list = [MockGTA5Radio().mediaList]
    }

    var isEmpty: Bool {
        !list.contains { !$0.items.isEmpty }
    }
}
