//
//  Uniforms.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 09.09.2023.
//

import simd
import SwiftUI

struct Uniforms {
    let pointCount: simd_int1

    let bias: simd_float1
    let power: simd_float1
    let noise: simd_float1

    let point0: simd_float2
    let point1: simd_float2
    let point2: simd_float2
    let point3: simd_float2
    let point4: simd_float2
    let point5: simd_float2
    let point6: simd_float2
    let point7: simd_float2

    let color0: simd_float4
    let color1: simd_float4
    let color2: simd_float4
    let color3: simd_float4
    let color4: simd_float4
    let color5: simd_float4
    let color6: simd_float4
    let color7: simd_float4
}

struct GradientParams {
    let points: ColorPoints
    let bias: Float
    let power: Float
    let noise: Float
}

extension Uniforms {
    init(params: GradientParams) {
        self.init(
            pointCount: 8,
            bias: params.bias,
            power: params.power,
            noise: params.noise,
            point0: params.points.point0.position.simd,
            point1: params.points.point1.position.simd,
            point2: params.points.point2.position.simd,
            point3: params.points.point3.position.simd,
            point4: params.points.point4.position.simd,
            point5: params.points.point5.position.simd,
            point6: params.points.point6.position.simd,
            point7: params.points.point7.position.simd,
            color0: params.points.point0.color.simd,
            color1: params.points.point1.color.simd,
            color2: params.points.point2.color.simd,
            color3: params.points.point3.color.simd,
            color4: params.points.point4.color.simd,
            color5: params.points.point5.color.simd,
            color6: params.points.point6.color.simd,
            color7: params.points.point7.color.simd
        )
    }
}

extension UnitPoint {
    var simd: simd_float2 { simd_float2(Float(x), Float(y)) }
}

extension Color {
    var simd: simd_float4 {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return simd_float4(Float(red), Float(green), Float(blue), Float(alpha))
    }
}
