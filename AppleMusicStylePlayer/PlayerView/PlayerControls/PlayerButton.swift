//
//  PlayerButton.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 18.12.2024.
//

import Combine
import SwiftUI

struct PlayerButton: View {
    @State private var pressed = false
    @GestureState private var startTimestamp: Date?

    var body: some View {
        Image(systemName: "play.fill")
            .padding(20)
            .background(pressed ? Color.blue : .clear)
            .onPressGesture(
                interval: 0.1,
                perform: {
                    print("onTapGesture")
                },
                onPressing: { time in
                    print("onPressing \(time)")
                },
                onEnded: {
                    print("onEnded")
                }
            )
    }
}

#Preview {
    PlayerButton()
}
