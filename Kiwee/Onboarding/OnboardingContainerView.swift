import SwiftUI

// MARK: - OnboardingContainerView

/// Root onboarding view — dark themed with dynamic gradient background,
/// segmented progress bar, back arrow, and bottom CTA.
struct OnboardingContainerView: View {
    @State private var viewModel = OnboardingViewModel()

    /// Called when the user completes onboarding. Passes the built `User`.
    let onComplete: (User) -> Void

    var body: some View {
        ZStack {
            // Dynamic gradient background — pinned to viewport, animates with avatar
            OnboardingBackground(theme: viewModel.theme)

            // Step content
            Group {
                switch viewModel.currentStep {
                case .welcome:
                    WelcomeStepView(theme: viewModel.theme) {
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

            // Navigation overlay — hidden on welcome & celebration
            if viewModel.currentStep != .welcome && viewModel.currentStep != .celebration {
                VStack(spacing: 0) {
                    // Top bar: back arrow + segmented progress bar
                    HStack(spacing: 12) {
                        if viewModel.currentStep.allowsBack {
                            Button {
                                viewModel.back()
                            } label: {
                                Image(systemName: "arrow.left")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .frame(width: 36, height: 36)
                            }
                            .buttonStyle(.plain)
                        } else {
                            Spacer().frame(width: 36)
                        }

                        OnboardingProgressBar(
                            currentStep: viewModel.currentStep,
                            accentColor: viewModel.theme.accent
                        )
                    }
                    .padding(.horizontal, KiweeTheme.Spacing.screenH)
                    .padding(.top, 8)

                    Spacer()

                    // Bottom CTA
                    OnboardingButton(
                        label: viewModel.currentStep.buttonLabel,
                        accentColor: viewModel.theme.accent,
                        isEnabled: viewModel.canAdvance
                    ) {
                        viewModel.next()
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
    .preferredColorScheme(.dark)
}
