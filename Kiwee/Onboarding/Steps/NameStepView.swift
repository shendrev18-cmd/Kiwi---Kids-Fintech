import SwiftUI

// MARK: - NameStepView

/// Collects the user's display name — dark theme with accent highlights.
struct NameStepView: View {
    @Bindable var viewModel: OnboardingViewModel
    @FocusState private var isFieldFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 80)

            // Emoji illustration
            Text("👋")
                .font(.system(size: 64))
                .padding(.bottom, 24)

            // Heading
            Text("What should we\ncall you?")
                .font(.lexend(.title, weight: .bold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            Text("This is how you'll appear in Kiwee.")
                .font(.figtree(.body, weight: .regular))
                .foregroundStyle(.white.opacity(0.5))
                .padding(.top, 8)

            Spacer().frame(height: 40)

            // Name input — dark card style
            TextField("Your name", text: $viewModel.userName)
                .font(.lexend(.title3, weight: .medium))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .textContentType(.givenName)
                .autocorrectionDisabled()
                .focused($isFieldFocused)
                .padding(.vertical, 16)
                .padding(.horizontal, 24)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.08))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(
                            isFieldFocused ? viewModel.theme.accent : Color.white.opacity(0.1),
                            lineWidth: 1.5
                        )
                )
                .padding(.horizontal, KiweeTheme.Spacing.screenH)

            // Live avatar preview
            if !viewModel.userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                GradientAvatarPreview(
                    emoji: viewModel.selectedAvatar.emoji,
                    gradientColors: [viewModel.theme.glowMid, viewModel.theme.glowWarm],
                    size: 80
                )
                .padding(.top, 32)
                .transition(.scale.combined(with: .opacity))
            }

            Spacer()
        }
        .animation(.spring(duration: 0.35), value: viewModel.userName)
        .onAppear { isFieldFocused = true }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        OnboardingBackground(theme: DynamicTheme())
        NameStepView(viewModel: OnboardingViewModel())
    }
    .preferredColorScheme(.dark)
}
