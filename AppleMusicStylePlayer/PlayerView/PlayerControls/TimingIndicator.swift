//
//  TimingIndicator.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 13.12.2024.
//

import SwiftUI

struct TimingIndicator: View {
    let spacing: CGFloat
    @State var value: CGFloat = 0.3

    var body: some View {
        VStack(spacing: spacing) {
            RubberSlider(
                value: $value,
                in: 0 ... 1,
                config: .playerControls
            )
            .transformEffect(.identity)

            HStack {
                Text("0:00")
                Spacer(minLength: 0)
                Text("3:33")
            }
            .blendMode(.overlay)
            .font(.caption)
            .foregroundColor(Color(palette.translucent))
        }
    }
}

private extension TimingIndicator {
    var palette: Palette.PlayerCard.Type {
        UIColor.palette.playerCard.self
    }
}

extension RubberSlider.Config {
    static var playerControls: Self {
        Self(
            minimumTrackActiveColor: Color(Palette.PlayerCard.opaque),
            minimumTrackInactiveColor: Color(Palette.PlayerCard.translucent),
            maximumTrackColor: Color(Palette.PlayerCard.transparent),
            blended: true
        )
    }
}

#Preview {
    ZStack {
        ColorfulBackground(colors: [.indigo, .pink])
        TimingIndicator(spacing: 10)
            .padding(.horizontal)
    }
    .ignoresSafeArea()
}
