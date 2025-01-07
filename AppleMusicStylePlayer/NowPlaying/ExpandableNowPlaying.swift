//
//  ExpandableNowPlaying.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 17.11.2024.
//

import SwiftUI

enum PlayerMatchedGeometry {
    case artwork
}

struct ExpandableNowPlaying: View {
    @Binding var show: Bool
    @Binding var expanded: Bool
    @Environment(NowPlayingController.self) var model
    @State private var offsetY: CGFloat = 0.0
    @State private var mainWindow: UIWindow?
    @State private var needRestoreProgressOnActive: Bool = false
    @State private var windowProgress: CGFloat = 0.0
    @State private var progressTrackState: CGFloat = 0.0
    @State private var expandProgress: CGFloat = 0.0
    @Environment(\.colorScheme) var colorScheme
    @Namespace private var animationNamespace

    var body: some View {
        expandableNowPlaying
            .onAppear {
                if let window = UIApplication.keyWindow {
                    mainWindow = window
                }
                model.onAppear()
            }
            .onChange(of: expanded) {
                if expanded {
                    stacked(progress: 1, withAnimation: true)
                }
            }
            .onPreferenceChange(NowPlayingExpandProgressPreferenceKey.self) { value in
                expandProgress = value
            }
    }
}

private extension ExpandableNowPlaying {
    var isFullExpanded: Bool {
        expandProgress >= 1
    }

    var expandableNowPlaying: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets

            ZStack(alignment: .top) {
                NowPlayingBackground(
                    colors: model.colors.map { Color($0.color) },
                    expanded: expanded,
                    isFullExpanded: isFullExpanded
                )
                CompactNowPlaying(
                    expanded: $expanded,
                    animationNamespace: animationNamespace
                )
                .opacity(expanded ? 0 : 1)

                RegularNowPlaying(
                    expanded: $expanded,
                    size: size,
                    safeArea: safeArea,
                    animationNamespace: animationNamespace
                )
                .opacity(expanded ? 1 : 0)
                ProgressTracker(progress: progressTrackState)
            }
            .frame(height: expanded ? nil : ViewConst.compactNowPlayingHeight, alignment: .top)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, expanded ? 0 : safeArea.bottom + ViewConst.compactNowPlayingHeight)
            .padding(.horizontal, expanded ? 0 : 12)
            .offset(y: offsetY)
            .gesture(
                PanGesture(
                    onChange: { handleGestureChange(value: $0, viewSize: size) },
                    onEnd: { handleGestureEnd(value: $0, viewSize: size) }
                )
            )
            .ignoresSafeArea()
        }
    }

    func handleGestureChange(value: PanGesture.Value, viewSize: CGSize) {
        guard expanded else { return }
        let translation = max(value.translation.height, 0)
        offsetY = translation
        windowProgress = max(min(translation / viewSize.height, 1), 0)
        stacked(progress: 1 - windowProgress, withAnimation: false)
    }

    func handleGestureEnd(value: PanGesture.Value, viewSize: CGSize) {
        guard expanded else { return }
        let translation = max(value.translation.height, 0)
        let velocity = value.velocity.height / 5
        withAnimation(.playerExpandAnimation) {
            if (translation + velocity) > (viewSize.height * 0.3) {
                expanded = false
                resetStackedWithAnimation()
            } else {
                stacked(progress: 1, withAnimation: true)
            }
            offsetY = 0
        }
    }

    func stacked(progress: CGFloat, withAnimation: Bool) {
        if withAnimation {
            SwiftUI.withAnimation(.playerExpandAnimation) {
                progressTrackState = progress
            }
        } else {
            progressTrackState = progress
        }

        mainWindow?.stacked(
            progress: progress,
            animationDuration: withAnimation ? Animation.playerExpandAnimationDuration : nil
        )
    }

    func resetStackedWithAnimation() {
        withAnimation(.playerExpandAnimation) {
            progressTrackState = 0
        }
        mainWindow?.resetStackedWithAnimation(duration: Animation.playerExpandAnimationDuration)
    }
}

extension Animation {
    static let playerExpandAnimationDuration: TimeInterval = 0.3
    static var playerExpandAnimation: Animation {
        .smooth(duration: playerExpandAnimationDuration, extraBounce: 0)
    }
}

private struct ProgressTracker: View, Animatable {
    var progress: CGFloat = 0

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    var body: some View {
        Color.clear
            .frame(width: 1, height: 1)
            .preference(key: NowPlayingExpandProgressPreferenceKey.self, value: progress)
    }
}

private extension UIWindow {
    func stacked(progress: CGFloat, animationDuration: TimeInterval?) {
        if let animationDuration {
            UIView.animate(
                withDuration: animationDuration,
                animations: {
                    self.stacked(progress: progress)
                },
                completion: { _ in
                    delay(animationDuration) {
                        self.resetStacked()
                    }
                }
            )
        } else {
            stacked(progress: progress)
        }
    }

    private func stacked(progress: CGFloat) {
        let offsetY = progress * 10
        layer.cornerRadius = 22
        layer.masksToBounds = true

        let scale = 1 - progress * 0.1
        transform = .identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: 0, y: offsetY)
    }

    func resetStackedWithAnimation(duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.resetStacked()
        }
    }

    private func resetStacked() {
        layer.cornerRadius = 0.0
        transform = .identity
    }
}

#Preview {
    OverlayableRootView {
        OverlaidRootView()
    }
}
