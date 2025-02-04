//
//  MulticolorGradient.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 09.09.2023.
//

import SwiftUI

struct MulticolorGradient: View, Animatable {
    var points: ColorPoints
    var animationUpdateHandler: (@Sendable (ColorPoints) -> Void)?

    var uniforms: Uniforms {
        Uniforms(params: GradientParams(points: points, bias: 0.05, power: 2.5, noise: 2))
    }

    nonisolated var animatableData: ColorPoints.AnimatableData {
        get {
            points.animatableData
        }
        set {
            let newPoints = ColorPoints(newValue)
            points = newPoints
            let viewCopy = self
            Task { @MainActor in
                viewCopy.animationUpdateHandler?(newPoints)
            }
        }
    }

    var body: some View {
        Rectangle()
            .colorEffect(ShaderLibrary.gradient(.boundingRect, .uniforms(uniforms)))
    }
}

@MainActor
private extension MulticolorGradient {
    mutating func updatePoints(newPoints: ColorPoints) {
        points = newPoints
        animationUpdateHandler?(newPoints)
    }
}

extension Shader.Argument {
    static func uniforms(_ param: Uniforms) -> Shader.Argument {
        var copy = param
        return .data(Data(bytes: &copy, count: MemoryLayout<Uniforms>.stride))
    }
}

#Preview {
    MulticolorGradient(
        points: ColorPoints(
            points: [
                ColorPoint(position: .top, color: .pink),
                ColorPoint(position: .leading, color: .indigo),
                ColorPoint(position: .bottomTrailing, color: .cyan)
            ]
        )
    )
    .ignoresSafeArea()
}
