//
//  VolumeSlider.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 24.12.2024.
//

import SwiftUI

public struct VolumeSlider: View {
    @State var volume: Double = 0.5
    @State var minVolumeAnimationTrigger: Bool = false
    @State var maxVolumeAnimationTrigger: Bool = false
    let range = 0.0 ... 1

    public var body: some View {
        ElasticSlider(
            value: $volume,
            in: range,
            leadingLabel: {
                Image(systemName: "speaker.fill")
                    .padding(.trailing, 10)
                    .symbolEffect(.bounce, value: minVolumeAnimationTrigger)
            },
            trailingLabel: {
                Image(systemName: "speaker.wave.3.fill")
                    .padding(.leading, 10)
                    .symbolEffect(.bounce, value: maxVolumeAnimationTrigger)
            }
        )
        .sliderStyle(.volume)
        .font(.system(size: 14))
        .onChange(of: volume) {
            if volume == range.lowerBound {
                minVolumeAnimationTrigger.toggle()
            }
            if volume == range.upperBound {
                maxVolumeAnimationTrigger.toggle()
            }
        }
        .frame(height: 50)
    }
}

extension ElasticSliderConfig {
    static var volume: Self {
        Self(
            labelLocation: .side,
            maxStretch: 10,
            minimumTrackActiveColor: Color(Palette.PlayerCard.opaque),
            minimumTrackInactiveColor: Color(Palette.PlayerCard.translucent),
            maximumTrackColor: Color(Palette.PlayerCard.translucent),
            blendMode: .overlay,
            syncLabelsStyle: true
        )
    }
}

#Preview {
    ZStack {
        PreviewBackground()
        VolumeSlider()
    }
    .ignoresSafeArea()
}
