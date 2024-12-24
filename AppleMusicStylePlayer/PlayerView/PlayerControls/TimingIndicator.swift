//
//  TimingIndicator.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 13.12.2024.
//

import SwiftUI

struct TimingIndicator: View {
    let spacing: CGFloat
    @State var progress: Double = 60
    let range = 0.0 ... 194

    var body: some View {
        ElasticSlider(
            value: $progress,
            in: range,
            leadingLabel: {
                label(leadingLabelText)
            },
            trailingLabel: {
                label(trailingLabelText)
            }
        )
        .sliderStyle(.playbackProgress)
        .frame(height: 60)
        .transformEffect(.identity)
    }
}

private extension TimingIndicator {
    func label(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 12, weight: .semibold))
            .padding(.top, 11)
    }

    var leadingLabelText: String {
        progress.asTimeString(style: .positional)
    }

    var trailingLabelText: String {
        ((range.upperBound - progress) * -1.0).asTimeString(style: .positional)
    }

    var palette: Palette.PlayerCard.Type {
        UIColor.palette.playerCard.self
    }
}

extension ElasticSliderConfig {
    static var playbackProgress: Self {
        Self(
            labelLocation: .bottom,
            maxStretch: 0,
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
        TimingIndicator(spacing: 10)
            .padding(.horizontal)
    }
}

extension BinaryFloatingPoint {
    func asTimeString(style: DateComponentsFormatter.UnitsStyle) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = style
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: TimeInterval(self)) ?? ""
    }
}
