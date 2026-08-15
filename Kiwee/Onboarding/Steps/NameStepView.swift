import SwiftUI

// MARK: - NameStepView

/// Collects the user's display name with a large, friendly text field.
struct NameStepView: View {
    @Bindable var viewModel: OnboardingViewModel
    @FocusState private var isFieldFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 40)

            // Emoji illustration
            Text("👋")
                .font(.system(size: 64))
                .padding(.bottom, 24)

            // Heading
            Text("What should we call you?")
                .font(.lexend(.title2, weight: .bold))
                .multilineTextAlignment(.center)

            Text("This is how you'll appear in Kiwee.")
                .font(.figtree(.body, weight: .regular))
                .foregroundStyle(.secondary)
                .padding(.top, 8)

            Spacer().frame(height: 40)

            // Name input
            TextField("Your name", text: $viewModel.userName)
                .font(.lexend(.title3, weight: .medium))
                .multilineTextAlignment(.center)
                .textContentType(.givenName)
                .autocorrectionDisabled()
                .focused($isFieldFocused)
                .padding(.vertical, 16)
                .padding(.horizontal, 24)
                .background(
                    RoundedRectangle(cornerRadius: KiweeTheme.Radius.card)
                        .fill(Color(.secondarySystemGroupedBackground))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: KiweeTheme.Radius.card)
                        .strokeBorder(
                            isFieldFocused ? Color.kiweeGreen : Color.clear,
                            lineWidth: 2
                        )
                )
                .padding(.horizontal, KiweeTheme.Spacing.screenH)

            // Live avatar preview
            if !viewModel.userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                GradientAvatarPreview(
                    initials: viewModel.avatarInitials,
                    gradientColors: viewModel.selectedGradient.colors,
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
    NameStepView(viewModel: OnboardingViewModel())
}
