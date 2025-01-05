//
//  MediaList.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 27.11.2024.
//

import Foundation

struct MediaList {
    let artwork: URL?
    let title: String
    let subtitle: String?
    let items: [Media]
}
