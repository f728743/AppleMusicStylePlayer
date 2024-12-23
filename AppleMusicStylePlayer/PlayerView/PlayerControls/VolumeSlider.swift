//
//  VolumeSlider.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 24.12.2024.
//

import SwiftUI

public struct VolumeSlider: View {
    @State var volume: Double = 0.5

    public var body: some View {
        RubberSlider(
            value: $volume,
            in: 0 ... 1,
            config: .volumeSlider,
            leadingLabel: {
                Image(systemName: "speaker.fill")
                    .padding(.trailing, 4)
            },
            trailingLabel: {
                Image(systemName: "speaker.wave.3.fill")
                    .padding(.leading, 4)
            }
        )
        .frame(height: 50)
    }
}

extension RubberSliderConfig {
    static var volumeSlider: Self {
        Self(
            labelLocation: .side,
            maxStretch: 10,
            minimumTrackActiveColor: Color(Palette.PlayerCard.opaque),
            minimumTrackInactiveColor: Color(Palette.PlayerCard.translucent),
            maximumTrackColor: Color(Palette.PlayerCard.transparent),
            blendMode: .overlay,
            syncLabelsStyle: true
        )
    }
}

#Preview {
    ZStack {
        ColorfulBackground(colors: [.indigo, .pink])
            .overlay(Color(UIColor(white: 0.4, alpha: 0.5)))
        VolumeSlider()
    }
    .ignoresSafeArea()
}
