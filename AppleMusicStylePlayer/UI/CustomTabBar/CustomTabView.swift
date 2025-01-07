//
//  CustomTabView.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 01.01.2025.
//

import SwiftUI

struct CustomTabView<Content: View>: View {
    @Binding var selection: TabBarItem
    let content: Content
    @State private var tabs: [TabBarItem] = []

    init(
        selection: Binding<TabBarItem>,
        @ViewBuilder content: () -> Content
    ) {
        _selection = selection
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            CustomTabBarView(
                tabs: tabs,
                selection: $selection,
                localSelection: selection
            )
        }
        .onPreferenceChange(TabBarItemsPreferenceKey.self) { value in
            tabs = value
        }
    }
}

// MARK: CustomTabBarView

private struct CustomTabBarView: View {
    let tabs: [TabBarItem]
    @Binding var selection: TabBarItem
    @State var localSelection: TabBarItem

    var body: some View {
        tabBar
            .onChange(of: selection) {
                withAnimation(.easeInOut) {
                    localSelection = selection
                }
            }
    }

    func tabView(_ tab: TabBarItem) -> some View {
        VStack(spacing: 5) {
            tab.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
            Text(tab.title)
                .font(.appFont.tabbar)
                .padding(.bottom, 2)
        }
        .foregroundStyle(localSelection == tab ? Color(.palette.brand) : Color.gray)
        .frame(maxWidth: .infinity)
    }

    var tabBar: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                tabView(tab)
                    .onTapGesture {
                        selection = tab
                    }
            }
        }
        .padding(.top, 68)
        .background(
            BlurView(style: .systemChromeMaterial)
                .mask(mask)
                .ignoresSafeArea(edges: .bottom)
        )
    }

    var mask: some View {
        VStack(spacing: 0) {
            LinearGradient(
                gradient: Gradient(colors: [.black.opacity(0.01), .black]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 30)
            Color.black
        }
    }
}

// MARK: Preference and ViewModifier

struct TabBarItemsPreferenceKey: PreferenceKey {
    static var defaultValue: [TabBarItem] = []

    static func reduce(value: inout [TabBarItem], nextValue: () -> [TabBarItem]) {
        value += nextValue()
    }
}

struct TabBarItemViewModifer: ViewModifier {
    let tab: TabBarItem
    @Binding var selection: TabBarItem

    func body(content: Content) -> some View {
        content
            .opacity(selection == tab ? 1.0 : 0.0)
            .preference(key: TabBarItemsPreferenceKey.self, value: [tab])
    }
}

struct TabBarItemViewModiferWithOnAppear: ViewModifier {
    let tab: TabBarItem
    @Binding var selection: TabBarItem

    @ViewBuilder func body(content: Content) -> some View {
        if selection == tab {
            content
                .opacity(1)
                .preference(key: TabBarItemsPreferenceKey.self, value: [tab])
        } else {
            Text("")
                .opacity(0)
                .preference(key: TabBarItemsPreferenceKey.self, value: [tab])
        }
    }
}

extension View {
    func tabBarItem(tab: TabBarItem, selection: Binding<TabBarItem>) -> some View {
        modifier(TabBarItemViewModiferWithOnAppear(tab: tab, selection: selection))
    }
}

#Preview {
    RootView()
        .environment(PlayListController())
}
