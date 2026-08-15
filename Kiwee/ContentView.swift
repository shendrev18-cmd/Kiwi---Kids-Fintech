import SwiftUI

/// The root app shell.
///
/// Uses the native iOS 26 `TabView` + `Tab` API so the floating Liquid
/// Glass capsule, morphing selection pill, and minimize-on-scroll
/// behavior are all rendered by the system — identical to first-party
/// Apple apps.
struct ContentView: View {
    @State private var selectedTab: KiweeTab = .home

    var body: some View {
        KiweeGlassTabBar(selectedTab: $selectedTab)
    }
}

#Preview {
    ContentView()
}
