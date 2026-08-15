import SwiftUI

// MARK: - AccountTypeStepView

/// Selection cards matching the dark reference: circle radio on left,
/// text in center, emoji on right.
struct AccountTypeStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer().frame(height: 80)

            // Heading — left-aligned like reference
            Text("Who are you?")
                .font(.lexend(.title, weight: .bold))
                .foregroundStyle(.white)
                .padding(.bottom, 8)

            Text("Let us know so we can personalize your experience.")
                .font(.figtree(.body, weight: .regular))
                .foregroundStyle(.white.opacity(0.5))

            Spacer().frame(height: 32)

            VStack(spacing: 12) {
                AccountTypeCard(
                    type: .kid,
                    description: "Earn money for chores, set savings goals, and learn to manage your money!",
                    isSelected: viewModel.selectedAccountType == .kid,
                    theme: viewModel.theme
                ) {
                    withAnimation(.easeOut(duration: 0.25)) {
                        viewModel.selectedAccountType = .kid
                    }
                }

                AccountTypeCard(
                    type: .parent,
                    description: "Set up allowances, assign chores, and help your kids build smart habits.",
                    isSelected: viewModel.selectedAccountType == .parent,
                    theme: viewModel.theme
                ) {
                    withAnimation(.easeOut(duration: 0.25)) {
                        viewModel.selectedAccountType = .parent
                    }
                }
            }

            Spacer()
        }
        .padding(.horizontal, KiweeTheme.Spacing.screenH)
    }
}

// MARK: - AccountTypeCard

/// Dark selection card: radio circle on left, text, emoji on right.
private struct AccountTypeCard: View {
    let type: AccountType
    let description: String
    let isSelected: Bool
    let theme: DynamicTheme
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                // Radio circle
                ZStack {
                    Circle()
                        .strokeBorder(
                            isSelected ? theme.accent : Color.white.opacity(0.25),
                            lineWidth: 2
                        )
                        .frame(width: 24, height: 24)

                    if isSelected {
                        Circle()
                            .fill(theme.accent)
                            .frame(width: 14, height: 14)
                    }
                }

                // Text
                VStack(alignment: .leading, spacing: 4) {
                    Text(type.label)
                        .font(.lexend(.subheadline, weight: .semibold))
                        .foregroundStyle(.white)

                    Text(description)
                        .font(.figtree(.caption, weight: .regular))
                        .foregroundStyle(.white.opacity(0.5))
                        .lineLimit(2)
                }

                Spacer()

                // Emoji
                Text(type.emoji)
                    .font(.system(size: 32))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(isSelected ? 0.10 : 0.06))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(
                        isSelected ? theme.accent.opacity(0.5) : Color.white.opacity(0.06),
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(type.label)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        OnboardingBackground(theme: DynamicTheme())
        AccountTypeStepView(viewModel: OnboardingViewModel())
    }
    .preferredColorScheme(.dark)
}
