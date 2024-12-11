//
//  PanGesture.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 17.11.2024.
//

import SwiftUI

struct PanGesture: UIGestureRecognizerRepresentable {
    var onChange: (Value) -> Void
    var onEnd: (Value) -> Void

    func makeUIGestureRecognizer(context _: Context) -> UIPanGestureRecognizer {
        let gesture = UIPanGestureRecognizer()
        return gesture
    }

    func updateUIGestureRecognizer(_: UIPanGestureRecognizer, context _: Context) {}

    func handleUIGestureRecognizerAction(_ recognizer: UIPanGestureRecognizer, context _: Context) {
        let state = recognizer.state
        let translation = recognizer.translation(in: recognizer.view).toSize()
        let velocity = recognizer.velocity(in: recognizer.view).toSize()
        let value = Value(translation: translation, velocity: velocity)

        if state == .began || state == .changed {
            onChange(value)
        } else {
            onEnd(value)
        }
    }

    struct Value {
        var translation: CGSize
        var velocity: CGSize
    }
}

extension CGPoint {
    func toSize() -> CGSize {
        CGSize(width: x, height: y)
    }
}
