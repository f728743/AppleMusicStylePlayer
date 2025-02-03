//
//  BlurView.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 07.01.2025.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
    let effect: UIVisualEffect
    let intensity: CGFloat

    init(effect: UIVisualEffect, intensity: CGFloat = 1) {
        self.effect = effect
        self.intensity = intensity
    }

    init(style: UIBlurEffect.Style, intensity: CGFloat = 1) {
        self.init(effect: UIBlurEffect(style: style), intensity: intensity)
    }

    func makeUIView(context _: Context) -> UIVisualEffectView {
        CustomVisualEffectView(effect: effect, intensity: intensity)
    }

    func updateUIView(_ uiView: UIVisualEffectView, context _: Context) {
        uiView.effect = effect
    }
}

final class CustomVisualEffectView: UIVisualEffectView {
    private let theEffect: UIVisualEffect
    private let intensity: CGFloat
    @MainActor private var animator: UIViewPropertyAnimator?

    init(effect: UIVisualEffect, intensity: CGFloat) {
        theEffect = effect
        self.intensity = intensity
        super.init(effect: nil)
    }

    required init?(coder _: NSCoder) { nil }

    deinit {
        let animator = self.animator
        self.animator = nil
        Task { @MainActor in
            animator?.stopAnimation(true)
        }
    }

    @MainActor
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        effect = nil
        animator?.stopAnimation(true)
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [unowned self] in
            self.effect = theEffect
        }
        animator?.fractionComplete = intensity
    }
}

#Preview {
    BlurView(style: .systemThickMaterial)
        .ignoresSafeArea()
}
