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
    static var playerCard: Palette.PlayerCard.Type {
        Palette.PlayerCard.self
    }

    static let appBackground: UIColor = .dynamic(
        light: .white,
        dark: .black
    )

    static let brand: UIColor = .dynamic(
        light: UIColor.systemPink,
        dark: UIColor.systemPink
    )

    static let artworkBorder: UIColor = .dynamic(
        light: .black.withAlphaComponent(0.2),
        dark: .white.withAlphaComponent(0.2)
    )

    static let artworkBackground: UIColor = .dynamic(
        light: UIColor(r: 233, g: 233, b: 234, a: 255),
        dark: UIColor(r: 39, g: 39, b: 41, a: 255)
    )

    static let buttonBackground: UIColor = .dynamic(
        light: UIColor(r: 238, g: 238, b: 239, a: 255),
        dark: UIColor(r: 28, g: 28, b: 31, a: 255)
    )

    static let textSecondary: UIColor = .dynamic(
        light: UIColor(r: 138, g: 138, b: 142, a: 255),
        dark: UIColor(r: 141, g: 141, b: 147, a: 255)
    )

    static let textTertiary: UIColor = .dynamic(
        light: UIColor(r: 127, g: 127, b: 127, a: 255),
        dark: UIColor(r: 128, g: 128, b: 128, a: 255)
    )

    static func appBackground(expandProgress: CGFloat) -> UIColor {
        UIColor {
            $0.userInterfaceStyle == .light
                ? .white
                : lerp(.black, .palette.stackedDarkBackground, expandProgress) ?? .black
        }
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

private extension Palette {
    static let taupeGray = UIColor(red: 0.525, green: 0.525, blue: 0.545, alpha: 1)
    static let platinum = UIColor(red: 0.898, green: 0.898, blue: 0.913, alpha: 1)
    static let stackedDarkBackground = UIColor(red: 0.0784, green: 0.0784, blue: 0.086, alpha: 1)
}

extension UIColor {
    static var palette: Palette.Type {
        Palette.self
    }
}

@inline(__always)
func lerp<V: BinaryFloatingPoint, T: BinaryFloatingPoint>(_ v0: V, _ v1: V, _ t: T) -> V {
    return v0 + V(t) * (v1 - v0)
}

func lerp<T: BinaryFloatingPoint>(_ v0: UIColor, _ v1: UIColor, _ t: T) -> UIColor? {
    var red0: CGFloat = 0
    var green0: CGFloat = 0
    var blue0: CGFloat = 0
    var alpha0: CGFloat = 0
    var red1: CGFloat = 0
    var green1: CGFloat = 0
    var blue1: CGFloat = 0
    var alpha1: CGFloat = 0

    v0.getRed(&red0, green: &green0, blue: &blue0, alpha: &alpha0)
    v1.getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1)
    return UIColor(
        red: lerp(red0, red1, t),
        green: lerp(green0, green1, t),
        blue: lerp(blue0, blue1, t),
        alpha: lerp(alpha0, alpha1, t)
    )
}
