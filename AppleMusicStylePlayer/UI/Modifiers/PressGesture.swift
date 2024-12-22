//
//  PressGesture.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 18.12.2024.
//

import Combine
import SwiftUI

struct PressGesture: ViewModifier {
    @GestureState private var startTimestamp: Date?
    @State private var timePublisher: Publishers.Autoconnect<Timer.TimerPublisher>
    private var onPressed: () -> Void
    private var onPressing: (TimeInterval) -> Void
    private var onEnded: () -> Void

    init(
        interval: TimeInterval = 0.1,
        onPressed: @escaping () -> Void,
        onPressing: @escaping (TimeInterval) -> Void,
        onEnded: @escaping () -> Void
    ) {
        self.onPressed = onPressed
        self.onPressing = onPressing
        self.onEnded = onEnded
        _timePublisher = State(
            wrappedValue: Timer.publish(
                every: interval,
                tolerance: nil,
                on: .current,
                in: .common
            ).autoconnect()
        )
    }

    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .updating($startTimestamp) { _, current, _ in
                        if current == nil {
                            onPressed()
                            current = Date()
                        }
                    }
                    .onEnded { _ in
                        onEnded()
                    }
            )
            .onReceive(timePublisher) { timer in
                if let startTimestamp = startTimestamp {
                    onPressing(timer.timeIntervalSince(startTimestamp))
                }
            }
    }
}

extension View {
    func onPressGesture(
        interval: TimeInterval = 0.1,
        onPressed: @escaping () -> Void,
        onPressing: @escaping (TimeInterval) -> Void,
        onEnded: @escaping () -> Void
    ) -> some View {
        modifier(
            PressGesture(
                interval: interval,
                onPressed: onPressed,
                onPressing: onPressing,
                onEnded: onEnded
            )
        )
    }
}
