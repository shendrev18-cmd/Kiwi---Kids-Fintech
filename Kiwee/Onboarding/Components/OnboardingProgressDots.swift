import SwiftUI

// MARK: - OnboardingProgressDots

/// Animated dot indicator showing current position in the onboarding flow.
/// The active dot is wider and uses the brand primary color.
struct OnboardingProgressDots: View {
    let currentStep: OnboardingStep

    var body: some View {
        HStack(spacing: 8) {
            ForEach(OnboardingStep.allCases, id: \.rawValue) { step in
                Capsule()
                    .fill(step == currentStep ? Color.kiweeGreen : Color.gray.opacity(0.3))
                    .frame(
                        width: step == currentStep ? 24 : 8,
                        height: 8
                    )
                    .animation(.spring(duration: 0.35), value: currentStep)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 30) {
        OnboardingProgressDots(currentStep: .welcome)
        OnboardingProgressDots(currentStep: .name)
        OnboardingProgressDots(currentStep: .avatar)
        OnboardingProgressDots(currentStep: .featureTour)
        OnboardingProgressDots(currentStep: .celebration)
    }
    .padding()
}
