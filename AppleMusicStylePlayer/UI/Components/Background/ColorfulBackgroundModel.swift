//
//  ColorfulBackgroundModel.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 24.09.2023.
//

import Combine
import SwiftUI

@MainActor
@Observable
class ColorfulBackgroundModel: @unchecked Sendable {
    static let animationDuration: Double = 20
    var points: ColorPoints = .zero.shuffled

    private var colors: [Color] = []
    private var shown = false
    private var animatedData: ColorPoints = .zero
    private var animatioTimerCancellable: AnyCancellable?

    func onAppear() {
        shown = true
        animate()
        animatedData = points

        animatioTimerCancellable = Timer
            .publish(every: Self.animationDuration * 0.9, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.animate()
            }
    }

    func onUpdate(animatedData: ColorPoints) {
        self.animatedData = animatedData
    }

    func set(_ colors: [Color]) {
        guard colors != self.colors else { return }
        self.colors = colors
        if shown {
            withAnimation {
                points = animatedData.colored(colors: colors)
            }
        } else {
            points = animatedData.colored(colors: colors)
        }
    }

    func animate() {
        withAnimation(.linear(duration: Self.animationDuration)) {
            points = points.shuffled
        }
    }
}

extension ColorPoint {
    static func random(withColor color: Color) -> ColorPoint {
        ColorPoint(
            position: UnitPoint(x: CGFloat.random(in: 0 ..< 1), y: CGFloat.random(in: 0 ..< 1)),
            color: color
        )
    }
}
