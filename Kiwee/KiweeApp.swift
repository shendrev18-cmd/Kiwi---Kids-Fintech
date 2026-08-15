import SwiftUI

@main
struct KiweeApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var user = User.sample

    init() {
        KiweeApp.configureAppearance()
    }

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                ContentView()
                    .environment(user)
                    .environment(\.font, .figtree(.body))
            } else {
                OnboardingContainerView { newUser in
                    user = newUser
                    withAnimation(.easeInOut(duration: 0.5)) {
                        hasCompletedOnboarding = true
                    }
                }
            }
        }
    }
}
