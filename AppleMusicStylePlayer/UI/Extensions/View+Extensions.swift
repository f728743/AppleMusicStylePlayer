//
//  View.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 13.12.2024.
//

import SwiftUI

extension View {
    func animationsDisabled(_ disabled: Bool) -> some View {
        transaction { (tx: inout Transaction) in
            tx.animation = tx.animation
            tx.disablesAnimations = disabled
        }
    }
}
