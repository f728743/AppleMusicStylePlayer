//
//  RubberSlider.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 13.12.2024.
//

import SwiftUI

struct RubberSlider<LeadingContent: View, TrailingContent: View>: View {
    @Binding private var value: CGFloat
    private var range: ClosedRange<CGFloat>
    private var config: Config
    @State private var lastStoredValue: CGFloat
    @State private var stretchingValue: CGFloat = 0
    @State private var viewSize: CGSize = .zero
    @GestureState private var isActive: Bool = false
    let leadingLabel: LeadingContent?
    let trailingLabel: TrailingContent?

    init(
        value: Binding<CGFloat>,
        in range: ClosedRange<CGFloat>,
        config: Config = .init(),
        leadingLabel: (() -> LeadingContent)? = nil,
        trailingLabel: (() -> TrailingContent)? = nil
    ) {
        _value = value
        self.range = range
        self.config = config
        lastStoredValue = value.wrappedValue
        self.leadingLabel = leadingLabel?()
        self.trailingLabel = trailingLabel?()
    }

    var body: some View {
        Group {
            if config.labelLocation == .bottom {
                bottomLabeledTrack
            } else {
                sideLabeledTrack
            }
        }
        .animation(.snappy, value: isActive)
    }

    struct Config {
        var labelLocation: LabelLocation = .side
        var activeHeight: CGFloat = 17
        var inactiveHeight: CGFloat = 7
        var maxStretch: CGFloat = 20
        var pushStretchRatio: CGFloat = 0.2
        var pullStretchRatio: CGFloat = 0.5
        var minimumTrackActiveColor: Color = .init(UIColor.tintColor)
        var minimumTrackInactiveColor: Color = .init(UIColor.tintColor)
        var maximumTrackColor: Color = .init(UIColor.systemFill)
        var blended: Bool = false
    }
}

private extension RubberSlider {
    var bottomLabeledTrack: some View {
        VStack(spacing: 0) {
            track
            HStack(spacing: 0) {
                let padding = (isActive ? 0 : config.growth) + config.maxStretch
                leadingLabel
                    .padding(.leading, padding - leadingStretch)
                Spacer()
                trailingLabel
                    .padding(.trailing, padding - trailingStretch)
            }
        }
    }

    var sideLabeledTrack: some View {
        HStack(spacing: 0) {
            let padding = (isActive ? 0 : config.growth) + config.maxStretch
            leadingLabel
                .offset(x: padding - leadingStretch)
            track
            trailingLabel
                .offset(x: trailingStretch - padding)
        }
    }

    var track: some View {
        GeometryReader { proxy in
            let size = proxy.size
            ZStack {
                Capsule()
                    .fill(config.maximumTrackColor)
                    .blendMode(config.blended ? .overlay : .normal)

                let fillWidth = normalized(value)
                    * trackWidth(for: size.width, active: isActive)
                    - leadingStretch
                    + trailingStretch
                Capsule()
                    .fill(isActive ? config.minimumTrackActiveColor : config.minimumTrackInactiveColor)
                    .blendMode(isActive ? .normal : config.blended ? .overlay : .normal)
                    .mask(
                        Rectangle()
                            .frame(width: fillWidth)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    )
            }
            .preference(key: SizePreferenceKey.self, value: size)
            .frame(
                height: isActive
                    ? config.activeHeight - abs(normalizedStretchingValue) * config.growth
                    : config.inactiveHeight
            )
            .padding(.horizontal, isActive ? 0 : config.growth)
            .padding(.leading, config.maxStretch - leadingStretch)
            .padding(.trailing, config.maxStretch - trailingStretch)
            .onPreferenceChange(SizePreferenceKey.self) { value in
                viewSize = value
            }
            .highPriorityGesture(
                DragGesture(minimumDistance: 0)
                    .updating($isActive) { _, out, _ in
                        out = true
                    }
                    .onChanged { value in
                        let progress = (value.translation.width / trackWidth(for: size.width, active: true))
                            * range.distance
                            + lastStoredValue
                        self.value = progress.clamped(to: range)
                        if progress < range.lowerBound {
                            stretchingValue = normalized(progress - range.lowerBound)
                        }
                        if progress > range.upperBound {
                            stretchingValue = normalized(progress - range.upperBound)
                        }
                    }
                    .onEnded { _ in
                        lastStoredValue = value
                        stretchingValue = 0
                    }
            )
        }
        .frame(
            height: max(0, isActive
                ? config.activeHeight - abs(normalizedStretchingValue) * config.growth
                : config.inactiveHeight)
        )
    }

    var normalizedStretchingValue: CGFloat {
        guard config.maxStretch != 0 else { return 0 }
        let trackWidth = activeTrackWidth
        guard trackWidth != 0, viewSize.width > config.maxStretch * 2 else { return 0 }
        let max = config.maxStretch / trackWidth / config.pushStretchRatio
        return stretchingValue.clamped(to: -max ... max) / max
    }

    var leadingStretch: CGFloat {
        let value = normalizedStretchingValue
        let stretch = abs(value) * config.maxStretch
        return value < 0 ? stretch : -stretch * config.pullStretchRatio
    }

    var trailingStretch: CGFloat {
        let value = normalizedStretchingValue
        let stretch = abs(value) * config.maxStretch
        return stretchingValue > 0 ? stretch : -stretch * config.pullStretchRatio
    }

    func normalized(_ value: CGFloat) -> CGFloat {
        (value - range.lowerBound) / range.distance
    }

    var activeTrackWidth: CGFloat {
        trackWidth(for: viewSize.width, active: true)
    }

    func trackWidth(for viewWidth: CGFloat, active: Bool) -> CGFloat {
        max(0, viewWidth - config.maxStretch * 2 - (active ? 0 : config.growth * 2))
    }
}

extension RubberSlider.Config {
    enum LabelLocation {
        case bottom
        case side
    }

    var growth: CGFloat {
        (activeHeight - inactiveHeight) / 2
    }
}

extension RubberSlider where LeadingContent == EmptyView {
    init(
        value: Binding<CGFloat>,
        in range: ClosedRange<CGFloat>,
        config: Config = .init(),
        trailingLabel: (() -> TrailingContent)? = nil
    ) {
        _value = value
        self.range = range
        self.config = config
        lastStoredValue = value.wrappedValue
        leadingLabel = nil
        self.trailingLabel = trailingLabel?()
    }
}

extension RubberSlider where TrailingContent == EmptyView {
    init(
        value: Binding<CGFloat>,
        in range: ClosedRange<CGFloat>,
        config: Config = .init(),
        leadingLabel: (() -> LeadingContent)? = nil
    ) {
        _value = value
        self.range = range
        self.config = config
        lastStoredValue = value.wrappedValue
        self.leadingLabel = leadingLabel?()
        trailingLabel = nil
    }
}

extension RubberSlider where LeadingContent == EmptyView, TrailingContent == EmptyView {
    init(
        value: Binding<CGFloat>,
        in range: ClosedRange<CGFloat>,
        config: Config = .init()
    ) {
        _value = value
        self.range = range
        self.config = config
        lastStoredValue = value.wrappedValue
        leadingLabel = nil
        trailingLabel = nil
    }
}

#Preview {
    @Previewable @State var progress: CGFloat = 0.5
    @Previewable @State var volume: CGFloat = 0.5
    let range = CGFloat(0) ... 2
    VStack(spacing: 50) {
        RubberSlider(
            value: $progress,
            in: range,
            config: .init(labelLocation: .bottom, maxStretch: 0),
            leadingLabel: {
                Text(progress, format: .number.precision(.fractionLength(2)))
            },
            trailingLabel: {
                Text(
                    (range.upperBound - progress) * -1.0,
                    format: .number.precision(.fractionLength(2))
                )
            }
        )
        .padding(.horizontal, 15)
        .frame(height: 50)

        RubberSlider(
            value: $volume,
            in: 0 ... 1,
            config: .init(labelLocation: .side),
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
