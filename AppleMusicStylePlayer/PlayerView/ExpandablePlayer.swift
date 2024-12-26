//
//  ExpandablePlayer.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 17.11.2024.
//

import SwiftUI

enum PlayerMatchedGeometry {
    case artwork
}

struct ExpandablePlayer: View {
    @Binding var show: Bool
    @Environment(PlayerController.self) var model
    @State private var expandPlayer: Bool = false
    @State private var offsetY: CGFloat = 0.0
    @State private var mainWindow: UIWindow?
    @State private var needRestoreProgressOnActive: Bool = false
    @State private var windowProgress: CGFloat = 0.0
    @State private var trackedProgress: CGFloat = 0.0
    @Namespace private var animationNamespace

    var body: some View {
        expandablePlayer
            .onAppear {
                if let window = UIApplication.keyWindow {
                    mainWindow = window
                    mainWindow?.backgroundColor = .green
                }
                model.onAppear()
            }
            .onChange(of: expandPlayer) {
                if expandPlayer {
                    stacked(progress: 1, withAnimation: true)
                }
            }
            .onReceive(appInactive) { _ in
                handeApp(active: false)
            }
            .onReceive(appActive) { _ in
                handeApp(active: true)
            }
    }
}

private extension ExpandablePlayer {
    var appInactive: NotificationCenter.Publisher {
        NotificationCenter
            .default
            .publisher(for: UIApplication.willResignActiveNotification)
    }

    var appActive: NotificationCenter.Publisher {
        NotificationCenter
            .default
            .publisher(for: UIApplication.didBecomeActiveNotification)
    }

    var expandablePlayer: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets

            ZStack(alignment: .top) {
                background(colors: model.colors.map { $0.color })
                MiniPlayer(
                    expanded: $expandPlayer,
                    animationNamespace: animationNamespace
                )
                .opacity(expandPlayer ? 0 : 1)

                ExpandedPlayer(
                    expanded: $expandPlayer,
                    size: size,
                    safeArea: safeArea,
                    animationNamespace: animationNamespace
                )
                .opacity(expandPlayer ? 1 : 0)
                ProgressTracker(progress: trackedProgress)
            }
            .frame(height: expandPlayer ? nil : 55, alignment: .top)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, expandPlayer ? 0 : safeArea.bottom + 55)
            .padding(.horizontal, expandPlayer ? 0 : 15)
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

    func background(colors: [UIColor]) -> some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
            ColorfulBackground(colors: model.colors.map { Color($0.color) })
                .overlay(Color(UIColor(white: 0.4, alpha: 0.5)))
                .opacity(expandPlayer ? 1 : 0)
        }
        .clipShape(.rect(cornerRadius: expandPlayer ? UIScreen.DeviceCornerRadius : 15))
        .frame(height: expandPlayer ? nil : 55)
        .shadow(color: .primary.opacity(0.06), radius: 5, x: 5, y: 5)
        .shadow(color: .primary.opacity(0.05), radius: 5, x: -5, y: -5)
    }

    func handleGestureChange(value: PanGesture.Value, viewSize: CGSize) {
        guard expandPlayer else { return }
        let translation = max(value.translation.height, 0)
        offsetY = translation
        windowProgress = max(min(translation / viewSize.height, 1), 0)
        stacked(progress: 1 - windowProgress, withAnimation: false)
    }

    func handleGestureEnd(value: PanGesture.Value, viewSize: CGSize) {
        guard expandPlayer else { return }
        let translation = max(value.translation.height, 0)
        let velocity = value.velocity.height / 5
        withAnimation(.playerExpandAnimation) {
            if (translation + velocity) > (viewSize.height * 0.3) {
                expandPlayer = false
                resetStackedWithAnimation()
            } else {
                stacked(progress: 1, withAnimation: true)
            }
            offsetY = 0
        }
    }

    func handeApp(active: Bool) {
        guard expandPlayer else { return }
        if active, needRestoreProgressOnActive {
            stacked(progress: 1, withAnimation: false)
        } else {
            needRestoreProgressOnActive = true
            mainWindow?.transform = .identity
        }
    }

    func stacked(progress: CGFloat, withAnimation: Bool) {
        if withAnimation {
            SwiftUI.withAnimation(.playerExpandAnimation) {
                trackedProgress = progress
            }
        } else {
            trackedProgress = progress
        }

        mainWindow?.stacked(
            progress: progress,
            animationDuration: withAnimation ? Animation.playerExpandAnimationDuration : nil
        )
    }

    func resetStackedWithAnimation() {
        withAnimation(.playerExpandAnimation) {
            trackedProgress = 0
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
            .preference(key: PlayerExpandProgressPreferenceKey.self, value: progress)
    }
}

private extension UIWindow {
    func stacked(progress: CGFloat, animationDuration: TimeInterval?) {
        if let animationDuration {
            UIView.animate(withDuration: animationDuration) {
                self.stacked(progress: progress)
            }
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
            self.layer.cornerRadius = 0.0
            self.transform = .identity
        }
    }
}

#Preview {
    OverlayableRootView {
        ApplicationView()
    }
}
