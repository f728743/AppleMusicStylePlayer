//
//  ColorfulBackground.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 20.09.2023.
//

import SwiftUI

struct ColorfulBackground: View {
    @State var model = ColorfulBackgroundModel()
    let colors: [Color]

    var body: some View {
        MulticolorGradient(
            points: model.points,
            animationUpdateHandler: { [weak model] newPoints in
                Task { @MainActor in
                    model?.onUpdate(animatedData: newPoints)
                }
            }
        )
        .onAppear {
            model.set(colors)
            model.onAppear()
        }
        .onChange(of: colors) {
            model.set(colors)
        }
    }
}

#Preview {
    ColorfulBackground(colors: [.pink, .indigo, .cyan])
        .ignoresSafeArea()
}
