//
//  Palette.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 04.12.2024.
//

import UIKit

enum Palette {
    enum PlayerCard {}
}

extension Palette {
    static let taupeGray = UIColor(red: 0.525, green: 0.525, blue: 0.545, alpha: 1)
    static let platinum = UIColor(red: 0.898, green: 0.898, blue: 0.913, alpha: 1)

    static var playerCard: Palette.PlayerCard.Type {
        Palette.PlayerCard.self
    }
}

extension Palette.PlayerCard {
    static let opaque: UIColor = .white
    static let translucent: UIColor = .init(white: 0.784, alpha: 0.816)
    static let artworkBackground: UIColor = .dynamic(
        light: Palette.platinum,
        dark: Palette.taupeGray
    )
}

extension UIColor {
    static var palette: Palette.Type {
        Palette.self
    }
}
