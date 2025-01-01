//
//  AppleMusicStylePlayerApp.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 17.11.2024.
//

import SwiftUI

@main
struct AppleMusicStylePlayerApp: App {
    var body: some Scene {
        WindowGroup {
            OverlayableRootView {
                OverlaidRootView()
            }
        }
    }
}
