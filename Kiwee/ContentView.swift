import SwiftUI

/// The root app shell.
///
/// Uses the native iOS 26 `TabView` + `Tab` API so the floating Liquid
/// Glass capsule, morphing selection pill, and minimize-on-scroll
/// behavior are all rendered by the system — identical to first-party
/// Apple apps.
///
/// `.environment(\.font, ...)` sets Inter as the default body font for
/// every `Text` in the hierarchy that doesn't apply its own `.font()`.
/// Inter handles the information/finance layer; Lexend and Figtree are
/// applied explicitly where brand or utility typography is needed.
struct ContentView: View {
    @State private var selectedTab: KiweeTab = .home

    var body: some View {
        KiweeGlassTabBar(selectedTab: $selectedTab)
            // Inter is the default body font (information + finance).
            .environment(\.font, .kiwee(.bodyMedium))
            .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
