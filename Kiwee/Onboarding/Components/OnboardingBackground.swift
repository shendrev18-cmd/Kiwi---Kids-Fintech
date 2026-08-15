import SwiftUI

// MARK: - OnboardingBackground

/// Full-bleed gradient background for onboarding screens.
/// Warm accent color bleeds up from the bottom ~35% of the screen,
/// fading to the near-black surface-base at the top. Pinned to the viewport.
struct OnboardingBackground: View {
    let theme: DynamicTheme

    var body: some View {
        LinearGradient(
            stops: [
                .init(color: theme.surfaceBase, location: 0.0),
                .init(color: theme.surfaceBase, location: 0.45),
                .init(color: theme.glowMid,     location: 0.75),
                .init(color: theme.glowWarm,    location: 1.0),
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        .animation(.easeOut(duration: 0.4), value: theme.seedHex)
    }
}

// MARK: - Preview

#Preview {
    OnboardingBackground(theme: DynamicTheme(seedHex: "#F97316"))
}
