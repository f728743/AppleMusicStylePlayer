//
//  RubberSlider.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 13.12.2024.
//

import SwiftUI

struct RubberSlider: View {
    @Binding private var value: CGFloat
    private var range: ClosedRange<CGFloat>
    private var config: Config
    @State private var lastStoredValue: CGFloat
    @GestureState private var isActive: Bool = false

    init(
        value: Binding<CGFloat>,
        in range: ClosedRange<CGFloat>,
        config: Config = .init()
    ) {
        _value = value
        self.range = range
        self.config = config
        lastStoredValue = value.wrappedValue
    }

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let width = (value / range.upperBound) * size.width
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(config.maximumTrackColor)
                    .blendMode(config.blended ? .overlay : .normal)

                Rectangle()
                    .fill(isActive ? config.minimumTrackActiveColor : config.minimumTrackInactiveColor)
                    .blendMode(isActive ? .normal : config.blended ? .overlay : .normal)
                    .mask(alignment: .leading) {
                        Rectangle()
                            .frame(width: width)
                    }
            }
            .contentShape(.rect)
            .highPriorityGesture(
                DragGesture(minimumDistance: 0)
                    .updating($isActive) { _, out, _ in
                        out = true
                    }
                    .onChanged { value in
                        let progress = (value.translation.width / size.width) * range.upperBound + self.lastStoredValue
                        self.value = max(min(progress, range.upperBound), range.lowerBound)
                    }
                    .onEnded { _ in
                        lastStoredValue = value
                    }
            )
        }
        .frame(height: config.activeHeight)
        .mask {
            RoundedRectangle(cornerRadius: config.activeHeight)
                .frame(height: isActive ? config.activeHeight : config.inactiveHeight)
        }
        .animation(.snappy, value: isActive)
    }

    struct Config {
        var activeHeight: CGFloat = 17
        var inactiveHeight: CGFloat = 7
        var minimumTrackActiveColor: Color = Color(UIColor.tintColor)
        var minimumTrackInactiveColor: Color = Color(UIColor.tintColor)
        var maximumTrackColor: Color = Color(UIColor.systemFill)
        var blended: Bool = true
    }
}

#Preview {
    @Previewable @State var value: CGFloat = 0.3
    VStack {
        RubberSlider(value: $value, in: 0 ... 1)
        Text(value, format: .number.precision(.fractionLength(2)))
    }
    .padding()
}
