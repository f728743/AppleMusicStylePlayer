//
//  ViewConst.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 04.12.2024.
//

import Foundation
import SwiftUI
import UIKit

enum ViewConst {}

@MainActor
extension ViewConst {
    static let playerCardPaddings: CGFloat = 32
    static let screenPaddings: CGFloat = 20
    static let tabbarHeight: CGFloat = safeAreaInsets.bottom + 92
    static let compactNowPlayingHeight: CGFloat = 56
    static var safeAreaInsets: EdgeInsets {
        if let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
           let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
            return EdgeInsets(window.safeAreaInsets)
        } else {
            return EdgeInsets(UIEdgeInsets.zero)
        }
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
