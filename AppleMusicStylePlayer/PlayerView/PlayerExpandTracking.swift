//
//  PlayerExpandTracking.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 26.12.2024.
//

import SwiftUI

struct PlayerExpandProgressPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

private struct PlayerExpandProgressEnvironmentKey: EnvironmentKey {
    static var defaultValue: Double = .zero
}

extension EnvironmentValues {
    var playerExpandProgress: CGFloat {
        get { self[PlayerExpandProgressEnvironmentKey.self] }
        set { self[PlayerExpandProgressEnvironmentKey.self] = newValue }
    }
}
