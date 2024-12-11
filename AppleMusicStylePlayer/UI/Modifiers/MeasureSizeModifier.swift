//
//  MeasureSizeModifier.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 03.12.2024.
//

import SwiftUI

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct MeasureSizeModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear.preference(key: SizePreferenceKey.self, value: geometry.size)
                }
            )
    }
}

extension View {
    func measureSize(completion: @escaping (CGSize) -> Void) -> some View {
        modifier(MeasureSizeModifier())
            .onPreferenceChange(SizePreferenceKey.self, perform: completion)
    }
}
