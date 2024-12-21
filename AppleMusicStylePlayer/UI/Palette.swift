//
//  Palette.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 04.12.2024.
//

import UIKit

enum Palette {
    enum PlayerCard {
        static let opaque: UIColor = .dynamic(
            light: .white,
            dark: .white
        )

        static let translucent: UIColor = .dynamic(
            light: .white.withAlphaComponent(0.5),
            dark: .white.withAlphaComponent(0.5)
        )

        static let transparent: UIColor = .dynamic(
            light: .white.withAlphaComponent(0.3),
            dark: .white.withAlphaComponent(0.3)
        )

        static let artworkBackground: UIColor = .dynamic(
            light: platinum,
            dark: taupeGray
        )
    }

    static var playerCard: Palette.PlayerCard.Type {
        Palette.PlayerCard.self
    }

    static let taupeGray = UIColor(red: 0.525, green: 0.525, blue: 0.545, alpha: 1)
    static let platinum = UIColor(red: 0.898, green: 0.898, blue: 0.913, alpha: 1)
}

extension UIColor {
    static var palette: Palette.Type {
        Palette.self
    }
}
