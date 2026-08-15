import SwiftUI

@main
struct KiweeApp: App {
    @State private var theme = KiweeTheme()

    init() {
        // Apply Lexend (nav bar) and Figtree (tab bar) to all UIKit-managed
        // surfaces before the first view renders.
        KiweeApp.configureAppearance()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(theme)
                .preferredColorScheme(.dark)
        }
    }
}
