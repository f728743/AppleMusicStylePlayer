//
//  ElasticSlider.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 13.12.2024.
//

import SwiftUI

struct ElasticSlider<LeadingContent: View, TrailingContent: View>: View {
    @Binding private var value: Double
    private let range: ClosedRange<Double>
    private let leadingLabel: LeadingContent?
    private let trailingLabel: TrailingContent?
    @Environment(\.elasticSliderConfig) var config
    @State private var lastStoredValue: CGFloat
    @State private var stretchingValue: CGFloat = 0
    @State private var viewSize: CGSize = .zero
    @GestureState private var isActive: Bool = false

    init(
        value: Binding<Double>,
        in range: ClosedRange<Double>,
        leadingLabel: (() -> LeadingContent)? = nil,
        trailingLabel: (() -> TrailingContent)? = nil
    ) {
        _value = value
        self.range = range
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
        .animation(.smooth(duration: 0.3, extraBounce: 0.3), value: isActive)
        .sensoryFeedback(.increase, trigger: isValueExtreme) { config.defaultSensoryFeedback && $1 }
    }
}

// MARK: private

private extension ElasticSlider {
    var isValueExtreme: Bool {
        value == range.lowerBound || value == range.upperBound
    }

    @ViewBuilder
    func styled<Content: View>(_ content: Content) -> some View {
        if config.syncLabelsStyle {
            ZStack {
                content
                    .foregroundColor(config.maximumTrackColor)
                    .blendMode(config.blendMode)
                content
                    .foregroundColor(isActive ? config.minimumTrackActiveColor : config.minimumTrackInactiveColor)
            }
            .animation(nil, value: isActive)
            .blendMode(isActive ? .normal : config.blendMode)
            .transformEffect(.identity)
        } else {
            content
        }
    }

    var bottomLabeledTrack: some View {
        VStack(spacing: 0) {
            track
            HStack(spacing: 0) {
                let padding = (isActive ? 0 : config.growth) + config.maxStretch
                styled(leadingLabel)
                    .padding(.leading, padding - leadingStretch)

                Spacer()
                styled(trailingLabel)
                    .padding(.trailing, padding - trailingStretch)
            }
        }
    }

    var sideLabeledTrack: some View {
        HStack(spacing: 0) {
            let padding = (isActive ? 0 : config.growth) + config.maxStretch
            styled(leadingLabel)
                .offset(x: padding - leadingStretch)
            track

            styled(trailingLabel)
                .offset(x: trailingStretch - padding)
        }
    }

    var track: some View {
        GeometryReader { proxy in
            let size = proxy.size
            ZStack {
                Capsule()
                    .fill(config.maximumTrackColor)
                    .blendMode(config.blendMode)

                let fillWidth = max(0, normalized(value)
                    * trackWidth(for: size.width, active: isActive)
                    - leadingStretch
                    + trailingStretch)
                Capsule()
                    .fill(isActive ? config.minimumTrackActiveColor : config.minimumTrackInactiveColor)
                    .blendMode(isActive ? .normal : config.blendMode)
                    .mask(
                        Rectangle()
                            .frame(width: fillWidth)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    )
            }
            .preference(key: SizePreferenceKey.self, value: size)
            .frame(
                height: isActive
                    ? config.activeHeight - abs(normalizedStretchingValue) * config.stretchNarrowing
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
                        self.value = Double(progress).clamped(to: range)
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
                ? config.activeHeight - abs(normalizedStretchingValue) * config.stretchNarrowing
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

// MARK: Convenience initializers

extension ElasticSlider where LeadingContent == EmptyView {
    init(
        value: Binding<Double>,
        in range: ClosedRange<Double>,
        trailingLabel: (() -> TrailingContent)? = nil
    ) {
        _value = value
        self.range = range
        lastStoredValue = value.wrappedValue
        leadingLabel = nil
        self.trailingLabel = trailingLabel?()
    }
}

extension ElasticSlider where TrailingContent == EmptyView {
    init(
        value: Binding<Double>,
        in range: ClosedRange<Double>,
        config _: ElasticSliderConfig = .init(),
        leadingLabel: (() -> LeadingContent)? = nil
    ) {
        _value = value
        self.range = range
        lastStoredValue = value.wrappedValue
        self.leadingLabel = leadingLabel?()
        trailingLabel = nil
    }
}

extension ElasticSlider where LeadingContent == EmptyView, TrailingContent == EmptyView {
    init(
        value: Binding<Double>,
        in range: ClosedRange<Double>,
        config _: ElasticSliderConfig = .init()
    ) {
        _value = value
        self.range = range
        lastStoredValue = value.wrappedValue
        leadingLabel = nil
        trailingLabel = nil
    }
}

// MARK: config

public struct ElasticSliderConfig {
    public enum LabelLocation {
        case bottom
        case side
    }

    public let labelLocation: LabelLocation
    public let activeHeight: CGFloat
    public let inactiveHeight: CGFloat
    public let growth: CGFloat
    public let stretchNarrowing: CGFloat
    public let maxStretch: CGFloat
    public let pushStretchRatio: CGFloat
    public let pullStretchRatio: CGFloat
    public let minimumTrackActiveColor: Color
    public let minimumTrackInactiveColor: Color
    public let maximumTrackColor: Color
    public let blendMode: BlendMode
    public let syncLabelsStyle: Bool
    public let defaultSensoryFeedback: Bool

    public init(
        labelLocation: ElasticSliderConfig.LabelLocation = .side,
        activeHeight: CGFloat = 17,
        inactiveHeight: CGFloat = 7,
        growth: CGFloat = 9,
        stretchNarrowing: CGFloat = 4,
        maxStretch: CGFloat = 9,
        pushStretchRatio: CGFloat = 0.2,
        pullStretchRatio: CGFloat = 0.5,
        minimumTrackActiveColor: Color = .init(UIColor.tintColor),
        minimumTrackInactiveColor: Color = .init(UIColor.systemGray3),
        maximumTrackColor: Color = .init(UIColor.systemGray6),
        blendMode: BlendMode = .normal,
        syncLabelsStyle: Bool = false,
        defaultSensoryFeedback: Bool = true
    ) {
        self.labelLocation = labelLocation
        self.activeHeight = activeHeight
        self.inactiveHeight = inactiveHeight
        self.growth = growth
        self.stretchNarrowing = stretchNarrowing
        self.maxStretch = maxStretch
        self.pushStretchRatio = pushStretchRatio
        self.pullStretchRatio = pullStretchRatio
        self.minimumTrackActiveColor = minimumTrackActiveColor
        self.minimumTrackInactiveColor = minimumTrackInactiveColor
        self.maximumTrackColor = maximumTrackColor
        self.blendMode = blendMode
        self.syncLabelsStyle = syncLabelsStyle
        self.defaultSensoryFeedback = defaultSensoryFeedback
    }
}

// MARK: EnvironmentValues

public extension View {
    func sliderStyle(_ config: ElasticSliderConfig = .init()) -> some View {
        environment(\.elasticSliderConfig, config)
    }
}

private struct ElasticSliderConfigEnvironmentKey: EnvironmentKey {
    static var defaultValue: ElasticSliderConfig = .init()
}

extension EnvironmentValues {
    var elasticSliderConfig: ElasticSliderConfig {
        get { self[ElasticSliderConfigEnvironmentKey.self] }
        set { self[ElasticSliderConfigEnvironmentKey.self] = newValue }
    }
}

#Preview {
    @Previewable @State var progress: Double = 0.5
    @Previewable @State var volume: Double = 0.5
    let range = 0.0 ... 2
    VStack(spacing: 50) {
        ElasticSlider(
            value: $progress,
            in: range,
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
        .sliderStyle(.init(labelLocation: .bottom, maxStretch: 0))
        .padding(.horizontal, 15)
        .frame(height: 50)

        ElasticSlider(
            value: $volume,
            in: 0 ... 1,
            leadingLabel: {
                Image(systemName: "speaker.fill")
                    .padding(.trailing, 4)
            },
            trailingLabel: {
                Image(systemName: "speaker.wave.3.fill")
                    .padding(.leading, 4)
            }
        )
        .sliderStyle(.init(labelLocation: .side, syncLabelsStyle: true))
        .frame(height: 50)
    }
}
