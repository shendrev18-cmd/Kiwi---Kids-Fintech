import SwiftUI

@main
struct KiweeApp: App {
    @State private var theme = KiweeTheme()
    @State private var hasCompletedOnboarding = false

    init() {
        // Apply Lexend (nav bar) and Figtree (tab bar) to all UIKit-managed
        // surfaces before the first view renders.
        KiweeApp.configureAppearance()
    }

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                ContentView()
                    .environment(theme)
                    .preferredColorScheme(.dark)
                    .transition(.opacity)
            } else {
                OnboardingView {
                    withAnimation(.easeOut(duration: 0.4)) {
                        hasCompletedOnboarding = true
                    }
                }
                .environment(theme)
                .preferredColorScheme(.dark)
                .transition(.opacity)
            }
        }
    }
}
