import SwiftUI

// MARK: - WelcomeStepView

/// Full-screen branded welcome with MeshGradient background.
struct WelcomeStepView: View {
    let onGetStarted: () -> Void

    @State private var logoScale: CGFloat = 0.6
    @State private var logoOpacity: Double = 0
    @State private var taglineOpacity: Double = 0
    @State private var buttonOpacity: Double = 0

    var body: some View {
        ZStack {
            // Full-bleed mesh gradient background
            MeshGradient(
                width: 3, height: 3,
                points: [
                    [0, 0], [0.5, 0], [1, 0],
                    [0, 0.5], [0.5, 0.5], [1, 0.5],
                    [0, 1], [0.5, 1], [1, 1]
                ],
                colors: KiweeTheme.Colors.heroGradientColors
            )
            .ignoresSafeArea()

            // Dark overlay for readability
            Color.black.opacity(0.3)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Kiwee logo / brand mark
                VStack(spacing: 16) {
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 72, weight: .bold))
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.2), radius: 8, y: 4)

                    Text("Kiwee")
                        .font(.lexend(size: 52, weight: .bold))
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)

                Spacer().frame(height: 24)

                // Tagline
                Text("The fun way to earn,\nsave, and spend.")
                    .font(.figtree(.title3, weight: .medium))
                    .foregroundStyle(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .opacity(taglineOpacity)

                Spacer()

                // Get Started button
                OnboardingButton(label: "Get Started") {
                    onGetStarted()
                }
                .padding(.horizontal, KiweeTheme.Spacing.screenH)
                .padding(.bottom, 24)
                .opacity(buttonOpacity)
            }
        }
        .onAppear {
            withAnimation(.spring(duration: 0.8).delay(0.2)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }
            withAnimation(.easeOut(duration: 0.6).delay(0.6)) {
                taglineOpacity = 1.0
            }
            withAnimation(.easeOut(duration: 0.6).delay(1.0)) {
                buttonOpacity = 1.0
            }
        }
    }
}

// MARK: - Preview

#Preview {
    WelcomeStepView(onGetStarted: {})
}
