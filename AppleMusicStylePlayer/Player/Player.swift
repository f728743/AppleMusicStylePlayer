//
//  Player.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 30.11.2024.
//

import Foundation

class Player {
    func play(_ media: Media) {
        print("Play \(media.title)")
    }

    func stop() {
        print("Stop")
    }
}
