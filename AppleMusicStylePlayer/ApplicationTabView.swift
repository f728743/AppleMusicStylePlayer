//
//  ApplicationTabView.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 27.11.2024.
//

import SwiftUI

struct ApplicationTabView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                MediaListView()
            }

            Tab("Search", systemImage: "magnifyingglass") {
                Text("Search")
            }

            Tab("Notifications", systemImage: "bell") {
                Text("Notifications")
            }

            Tab("Settings", systemImage: "gearshape") {
                Text("Settings")
            }
        }
    }
}

#Preview {
    ApplicationTabView()
}
