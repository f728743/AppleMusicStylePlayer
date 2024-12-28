//
//  ForwardLabel.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 31.12.2024.
//

import SwiftUI

struct AnimatedForwardLabel: View {
    class PublishedWrapper: ObservableObject {
        @Published var trigger: PlayerButtonTrigger = .one(bouncing: false)
    }

    let size: CGFloat
    var trigger: PlayerButtonTrigger
    var animationDuration: Double = 0.3
    @State var changeCount = 0
    @StateObject var published = PublishedWrapper()
    @State var animationTrigger: Bool = true
    @State var bouncing: Bool = false

    var body: some View {
        AnimationWrapper(size: size, linear: !bouncing, progress: animationTrigger ? 0 : 1)
            .onChange(of: trigger) {
                published.trigger = trigger
            }
            .onReceive(
                published.$trigger.dropFirst().throttle(
                    for: RunLoop.SchedulerTimeType.Stride(animationDuration),
                    scheduler: RunLoop.main,
                    latest: true
                )
            ) { value in
                switch value {
                case let .one(bouncing): self.bouncing = bouncing
                case let .another(bouncing): self.bouncing = bouncing
                }
                withAnimation(.linear(duration: animationDuration * 0.9)) {
                    animationTrigger.toggle()
                } completion: {
                    animationTrigger.toggle()
                }
            }
    }
}

private struct ForwardLabel: View {
    let size: CGFloat
    var linear: Bool = false
    var progress: Double
    let sideFraction = 0.3

    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                gliph
                    .padding(.leading, leftOffset)
                    .opacity(progress)

                gliph
                    .frame(width: size / 2)

                gliph
                    .frame(width: rightWidth)
                    .padding(.trailing, rightOffset)
                    .opacity(1 - progress)
            }
        }
        .frame(width: width, height: size)
    }

    var side: CGFloat { size * sideFraction }
    var width: CGFloat { size + side * 2 }

    var leftOffset: CGFloat {
        let res = min(sideFraction, progress) * size +
            (1 - leftGrowthProgress) * side +
            rightProtrusionProgress * side
        return res
    }

    var rightOffset: CGFloat {
        let res = max(0, sideFraction - progress) * size
            + rightShrinkProgress * side
        return res
    }

    var rightWidth: CGFloat {
        let res = lerp(0, size / 2, 1 - scaleProgress)
        return res
    }

    var scaleProgress: Double {
        max(0, (progress - sideFraction) / (1.0 - sideFraction))
    }

    var leftGrowthProgress: Double {
        let progress = min(1, progress / sideFraction)
        return linear ? progress : sqrt(progress)
    }

    var linearRightShrinkProgress: Double {
        let progress = max(0, scaleProgress - (1 - sideFraction * 2)) / sideFraction / 2
        return progress
    }

    var rightShrinkProgress: Double {
        return linear ? linearRightShrinkProgress : linearRightShrinkProgress * linearRightShrinkProgress
    }

    var rightProtrusionProgress: Double {
        linearRightShrinkProgress - rightShrinkProgress
    }

    var gliph: some View {
        Image(systemName: "play.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

private struct AnimationWrapper: View, Animatable {
    let size: CGFloat
    let linear: Bool
    var progress: Double

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    var body: some View {
        ForwardLabel(
            size: size,
            linear: linear,
            progress: progress.clamped(
                to: 0 ... 1
            )
        )
    }
}

#Preview {
    @Previewable let size: CGFloat = 50
    @Previewable @State var trigger: PlayerButtonTrigger = .one(bouncing: false)
    VStack(spacing: 30) {
        AnimatedForwardLabel(size: size, trigger: trigger)

        Button("Animate bouncing") {
            trigger.toggle(bouncing: true)
        }
        .padding(20)

        Button("Animate linea") {
            trigger.toggle(bouncing: false)
        }
    }
}
