//
//  ClosedRange+Extensions.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 22.12.2024.
//

import Foundation

extension ClosedRange where Bound: AdditiveArithmetic {
    var distance: Bound {
        upperBound - lowerBound
    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
