//
//  AppFont.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 26.12.2024.
//

import SwiftUI

enum AppFont {
    static let timingIndicator: Font = .system(size: 12, weight: .semibold)
    static let miniPlayerTitle: Font = .system(size: 15, weight: .medium)
    static let button: Font = .system(size: 17, weight: .semibold)
    static let mediaListHeaderTitle: Font = .system(size: 20, weight: .semibold)
    static let mediaListHeaderSubtitle: Font = .system(size: 20, weight: .regular)
    static let mediaListItemTitle: Font = .system(size: 16, weight: .regular)
    static let mediaListItemSubtitle: Font = .system(size: 13, weight: .regular)
    static let mediaListItemFooter: Font = .system(size: 15, weight: .regular)
    static let tabbar: Font = .system(size: 10, weight: .regular)
}

extension Font {
    static var appFont: AppFont.Type {
        AppFont.self
    }
}
