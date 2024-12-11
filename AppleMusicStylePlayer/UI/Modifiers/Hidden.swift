//
//  Hidden.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 08.12.2024.
//

import SwiftUI

extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}
