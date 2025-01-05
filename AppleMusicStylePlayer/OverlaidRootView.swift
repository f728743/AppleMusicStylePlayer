//
//  OverlaidRootView.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 17.11.2024.
//

import SwiftUI

struct OverlaidRootView: View {
    @State private var playlistController: PlayListController
    @State private var playerController: NowPlayingController
    @State private var nowPlayingExpandProgress: CGFloat = .zero
    @State private var showOverlayingNowPlayng: Bool = true
    @State private var expandedNowPlaying: Bool = false
    @State private var showNowPlayingReplacement: Bool = false

    init() {
        let playlistController = PlayListController()
        playerController = NowPlayingController(
            playList: playlistController,
            player: Player()
        )
        self.playlistController = playlistController
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            RootView()
            CompactNowPlayingReplacement(expanded: .constant(false))
                .opacity(showNowPlayingReplacement ? 1 : 0)
        }
        .environment(playerController)
        .environment(playlistController)
        .universalOverlay(animation: .none, show: $showOverlayingNowPlayng) {
            ExpandableNowPlaying(
                show: $showOverlayingNowPlayng,
                expanded: $expandedNowPlaying
            )
            .environment(playerController)
            .onPreferenceChange(NowPlayingExpandProgressPreferenceKey.self) { value in
                nowPlayingExpandProgress = value
            }
        }
        .environment(\.nowPlayingExpandProgress, nowPlayingExpandProgress)
    }
    
    func showNowPlayng(replacement: Bool) {
        guard !expandedNowPlaying else { return }
        showOverlayingNowPlayng = !replacement
        showNowPlayingReplacement = replacement
    }
}
        
private struct CompactNowPlayingReplacement: View {
    @Namespace private var animationNamespaceStub
    @Binding var expanded: Bool
    var body: some View {
        ZStack(alignment: .top) {
            NowPlayingBackground(
                colors: [],
                expanded: false,
                isFullExpanded: false,
                canBeExpanded: false
            )
            CompactNowPlaying(
                expanded: $expanded,
                hideArtworkOnExpanded: false,
                animationNamespace: animationNamespaceStub
            )
        }
        .padding(.horizontal, 12)
        .padding(.bottom, ViewConst.compactNowPlayingHeight)
    }
}

#Preview {
    OverlayableRootView {
        OverlaidRootView()
    }
}
