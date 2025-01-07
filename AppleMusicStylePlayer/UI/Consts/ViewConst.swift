//
//  ViewConst.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 04.12.2024.
//

import Foundation
import SwiftUI

enum ViewConst {}

extension ViewConst {
    static let playerCardPaddings: CGFloat = 32
    static let screenPaddings: CGFloat = 20
    static let tabbarHeight: CGFloat = safeAreaInsets.bottom + 92
    static let compactNowPlayingHeight: CGFloat = 56
    static var safeAreaInsets: EdgeInsets {
        EdgeInsets(UIApplication.keyWindow?.safeAreaInsets ?? .zero)
    }
}

extension EdgeInsets {
    init(_ insets: UIEdgeInsets) {
        self.init(
            top: insets.top,
            leading: insets.left,
            bottom: insets.bottom,
            trailing: insets.right
        )
    }
}
