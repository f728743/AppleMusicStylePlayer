//
//  Time.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 20.12.2024.
//

import Foundation

public func delay(_ delay: Double, closure: @escaping @Sendable () -> Void) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}
