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
    private var perform: () -> Void
    private var onPressing: (TimeInterval) -> Void
    private var onEnded: () -> Void

    init(
        interval: TimeInterval = 0.1,
        perform: @escaping () -> Void,
        onPressing: @escaping (TimeInterval) -> Void,
        onEnded: @escaping () -> Void
    ) {
        self.perform = perform
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
                    .updating($startTimestamp, body: { _, current, _ in
                        if current == nil {
                            perform()
                            current = Date()
                        }
                    })
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
        perform: @escaping () -> Void,
        onPressing: @escaping (TimeInterval) -> Void,
        onEnded: @escaping () -> Void
    ) -> some View {
        modifier(
            PressGesture(
                interval: interval,
                perform: perform,
                onPressing: onPressing,
                onEnded: onEnded
            )
        )
    }
}
