import SwiftUI

// MARK: - OnboardingContainerView

/// Root onboarding view that manages step transitions, progress dots,
/// and Next/Back navigation. Shown instead of the tab bar on first launch.
struct OnboardingContainerView: View {
    @State private var viewModel = OnboardingViewModel()

    /// Called when the user completes onboarding. Passes the built `User`.
    let onComplete: (User) -> Void

    var body: some View {
        ZStack {
            // Background
            KiweeTheme.Colors.screenBackground
                .ignoresSafeArea()

            // Step content
            Group {
                switch viewModel.currentStep {
                case .welcome:
                    WelcomeStepView {
                        viewModel.next()
                    }
                case .name:
                    NameStepView(viewModel: viewModel)
                case .avatar:
                    AvatarStepView(viewModel: viewModel)
                case .accountType:
                    AccountTypeStepView(viewModel: viewModel)
                case .firstGoal:
                    FirstGoalStepView(viewModel: viewModel)
                case .featureTour:
                    FeatureTourStepView(viewModel: viewModel)
                case .celebration:
                    CelebrationStepView(viewModel: viewModel) {
                        onComplete(viewModel.buildUser())
                    }
                }
            }
            .transition(.asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity),
                removal: .move(edge: .leading).combined(with: .opacity)
            ))

            // Navigation overlay (progress dots + buttons) — hidden on welcome & celebration
            if viewModel.currentStep != .welcome && viewModel.currentStep != .celebration {
                VStack {
                    // Progress dots at top
                    OnboardingProgressDots(currentStep: viewModel.currentStep)
                        .padding(.top, 16)

                    Spacer()

                    // Bottom navigation buttons
                    VStack(spacing: 12) {
                        OnboardingButton(
                            label: viewModel.currentStep.buttonLabel,
                            isEnabled: viewModel.canAdvance
                        ) {
                            viewModel.next()
                        }

                        if viewModel.currentStep.allowsBack {
                            OnboardingButton(
                                label: "Back",
                                style: .secondary
                            ) {
                                viewModel.back()
                            }
                        }
                    }
                    .padding(.horizontal, KiweeTheme.Spacing.screenH)
                    .padding(.bottom, 24)
                }
            }
        }
        .animation(.easeInOut(duration: 0.35), value: viewModel.currentStep)
    }
}

// MARK: - Preview

#Preview("Onboarding Flow") {
    OnboardingContainerView { user in
        print("Onboarding complete for \(user.name)")
    }
}
