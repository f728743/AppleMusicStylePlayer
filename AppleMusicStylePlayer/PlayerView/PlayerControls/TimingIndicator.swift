//
//  TimingIndicator.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 13.12.2024.
//

import SwiftUI

struct TimingIndicator: View {
    let spacing: CGFloat
    var body: some View {
        VStack(spacing: spacing) {
            Capsule()
                .fill(.ultraThinMaterial)
                .environment(\.colorScheme, .light)
                .frame(height: 5)
            HStack {
                Text("0:00")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer(minLength: 0)
                Text("3:33")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    TimingIndicator(spacing: 10)
        .padding(.horizontal)
}
