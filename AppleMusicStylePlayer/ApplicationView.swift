//
//  ApplicationView.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 17.11.2024.
//

import SwiftUI

struct ApplicationView: View {
    @State private var showMiniPlayer: Bool = false
    @State var playlistController: PlayListController
    @State var playerController: PlayerController

    init() {
        let playlistController = PlayListController()
        playerController = PlayerController(
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
                ExpandablePlayer(show: $showMiniPlayer)
                    .environment(playerController)
            }
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
