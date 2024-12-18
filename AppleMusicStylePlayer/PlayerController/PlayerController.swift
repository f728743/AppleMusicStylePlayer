//
//  PlayerController.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 27.11.2024.
//

import Kingfisher
import Observation
import UIKit

@Observable
class PlayerController {
    enum State {
        case playing
        case paused
    }

    var state: State = .paused
    var currentIndex: Int? = 1
    private let playList: PlayListController
    private let player: Player
    var colors: [ColorFrequency] = []

    var currentMedia: Media? {
        guard let currentIndex else { return nil }
        return playList.items[safe: currentIndex]
    }

    init(playList: PlayListController, player: Player) {
        self.playList = playList
        self.player = player
    }

    var display: Media {
        currentMedia ?? .placeholder
    }

    var title: String {
        display.title
    }

    var subtitle: String? {
        display.subtitle
    }

    var playPauseButton: ButtonType {
        switch state {
        case .playing: currentMedia.map(\.online) ?? false ? .stop : .pause
        case .paused: .play
        }
    }
    
    var backwardButton: ButtonType { .backward }
    var forwardButton: ButtonType { .forward }


    func onPlayPause() {
        enshureMediaAvailable()
        guard let currentMedia else { return }
        state.toggle()
        if state == .playing {
            player.play(currentMedia)
        } else {
            player.stop()
        }
    }

    func onForward() {
        enshureMediaAvailable()
        guard currentMedia != nil else { return }

        guard let currentIndex else {
            self.currentIndex = 0
            return
        }

        var next = currentIndex + 1
        if next >= playList.items.count {
            next = 0
        }
        self.currentIndex = next
        updateColors()
    }

    func onBackward() {
        enshureMediaAvailable()
        guard currentMedia != nil else { return }

        let lastIndex = playList.items.count - 1
        guard let currentIndex else {
            self.currentIndex = lastIndex
            return
        }

        var prev = currentIndex - 1
        if prev < 0 {
            prev = lastIndex
        }
        self.currentIndex = prev
        updateColors()
    }
}

private extension PlayerController {
    func enshureMediaAvailable() {
        if playList.items.isEmpty {
            selectFirstAvailableMedia()
        }
    }

    func selectFirstAvailableMedia() {
        stopPlaying()
        playList.selectFirstAvailable()
        currentIndex = playList.items.isEmpty ? nil : 0
    }

    func stopPlaying() {
        state = .paused
        player.stop()
    }

    func updateColors() {
        guard let url = display.artwork else { return }
        KingfisherManager.shared.retrieveImage(
            with: url,
            options: nil,
            progressBlock: nil
        ) { [weak self] result in
            if case let .success(image) = result {
                self?.colors = (image.image.dominantColorFrequencies(with: .high) ?? [])
            }
        }
    }
}

private extension PlayerController.State {
    mutating func toggle() {
        switch self {
        case .playing: self = .paused
        case .paused: self = .playing
        }
    }
}

private extension Media {
    static var placeholder: Self {
        Media(
            artwork: nil,
            title: "---",
            subtitle: "---",
            online: false
        )
    }
}
