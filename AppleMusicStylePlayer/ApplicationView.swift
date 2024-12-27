//
//  ApplicationView.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 17.11.2024.
//

import SwiftUI

struct ApplicationView: View {
    @State private var showMiniPlayer: Bool = false
    @State private var playlistController: PlayListController
    @State private var playerController: NowPlayingController
    @State private var nowPlayingExpandProgress: CGFloat = .zero

    init() {
        let playlistController = PlayListController()
        playerController = NowPlayingController(
            playList: playlistController,
            player: Player()
        )
        self.playlistController = playlistController
    }

    var body: some View {
        ApplicationTabView()
            .environment(playerController)
            .environment(playlistController)
            .universalOverlay(show: $showMiniPlayer) {
                ExpandableNowPlaying(show: $showMiniPlayer)
                    .environment(playerController)
                    .onPreferenceChange(NowPlayingExpandProgressPreferenceKey.self) { value in
                        nowPlayingExpandProgress = value
                    }
            }
            .environment(\.nowPlayingExpandProgress, nowPlayingExpandProgress)
            .onAppear {
                showMiniPlayer = true
            }
    }
}

#Preview {
    OverlayableRootView {
        ApplicationView()
    }
}
