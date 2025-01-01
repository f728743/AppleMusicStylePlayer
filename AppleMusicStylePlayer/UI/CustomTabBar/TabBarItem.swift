//
//  TabBarItem.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 01.01.2025.
//

import SwiftUI

enum TabBarItem: Hashable, CaseIterable {
    case home, search
}

extension TabBarItem {
    var title: String {
        switch self {
        case .home: return "Home"
        case .search: return "Search"
        }
    }

    var image: Image {
        switch self {
        case .home: return Image("img_home")
        case .search: return Image(systemName: "magnifyingglass")
        }
    }
}
