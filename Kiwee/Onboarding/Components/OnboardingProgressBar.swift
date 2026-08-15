import SwiftUI

// MARK: - OnboardingProgressBar

/// Segmented progress bar matching the dark onboarding reference.
/// Each step is a capsule segment; completed steps are filled with the accent color.
struct OnboardingProgressBar: View {
    let currentStep: OnboardingStep
    var accentColor: Color = .kiweeGreen

    var body: some View {
        HStack(spacing: 4) {
            ForEach(OnboardingStep.allCases, id: \.rawValue) { step in
                Capsule()
                    .fill(step.rawValue <= currentStep.rawValue
                          ? accentColor
                          : Color.white.opacity(0.15))
                    .frame(height: 4)
                    .animation(.easeInOut(duration: 0.3), value: currentStep)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 30) {
        OnboardingProgressBar(currentStep: .welcome)
        OnboardingProgressBar(currentStep: .name)
        OnboardingProgressBar(currentStep: .avatar, accentColor: .purple)
        OnboardingProgressBar(currentStep: .featureTour, accentColor: .cyan)
        OnboardingProgressBar(currentStep: .celebration, accentColor: .orange)
    }
    .padding()
    .background(Color.black)
}
