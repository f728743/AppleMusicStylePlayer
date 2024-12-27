//
//  PlayerExpandTracking.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 26.12.2024.
//

import SwiftUI

struct NowPlayingExpandProgressPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

private struct NowPlayingExpandProgressEnvironmentKey: EnvironmentKey {
    static var defaultValue: Double = .zero
}

extension EnvironmentValues {
    var nowPlayingExpandProgress: CGFloat {
        get { self[NowPlayingExpandProgressEnvironmentKey.self] }
        set { self[NowPlayingExpandProgressEnvironmentKey.self] = newValue }
    }
}
