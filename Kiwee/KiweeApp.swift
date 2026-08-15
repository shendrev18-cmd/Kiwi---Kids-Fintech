import SwiftUI

@main
struct KiweeApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var user = User.loadOrSample()

    init() {
        KiweeApp.configureAppearance()
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if hasCompletedOnboarding {
                    ContentView()
                        .environment(user)
                        .environment(\.font, .figtree(.body))
                } else {
                    OnboardingContainerView { newUser in
                        user = newUser
                        newUser.save()
                        withAnimation(.easeInOut(duration: 0.5)) {
                            hasCompletedOnboarding = true
                        }
                    }
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}
