import SwiftUI

/// The root app shell.
///
/// Uses the native iOS 26 `TabView` + `Tab` API so the floating Liquid
/// Glass capsule, morphing selection pill, and minimize-on-scroll
/// behavior are all rendered by the system — identical to first-party
/// Apple apps.
///
/// `.environment(\.font, ...)` here sets Figtree as the default font for
/// every `Text` in the hierarchy that doesn't apply its own `.font()` modifier.
struct ContentView: View {
    @State private var selectedTab: KiweeTab = .home

    var body: some View {
        KiweeGlassTabBar(selectedTab: $selectedTab)
            // Figtree is the default body font for all unstyled Text views.
            .environment(\.font, .figtree(.body))
    }
}

#Preview {
    ContentView()
}
