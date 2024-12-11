//
//  Palette.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 04.12.2024.
//

import UIKit

struct Palette {
    struct PlayerCard {
        static let opaque: UIColor = UIColor.dynamic(
            light: .white,
            dark: .white
        )

        static let translucent: UIColor = UIColor.dynamic(
            light: .white.withAlphaComponent(0.5),
            dark: .white.withAlphaComponent(0.5)
        )

        static let transparent: UIColor = UIColor.dynamic(
            light: .white.withAlphaComponent(0.3),
            dark: .white.withAlphaComponent(0.3)
        )
    }

    static var playerCard: Palette.PlayerCard.Type {
        Palette.PlayerCard.self
    }
}

extension UIColor {
    static var palette: Palette.Type {
        Palette.self
    }
}