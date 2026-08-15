import SwiftUI

// MARK: - AccountTypeStepView

/// Two large tappable cards for selecting Kid or Parent account type.
struct AccountTypeStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 40)

            Text("Who are you?")
                .font(.lexend(.title2, weight: .bold))
                .padding(.bottom, 8)

            Text("We'll tailor Kiwee just for you.")
                .font(.figtree(.body, weight: .regular))
                .foregroundStyle(.secondary)

            Spacer().frame(height: 40)

            VStack(spacing: 16) {
                AccountTypeCard(
                    type: .kid,
                    isSelected: viewModel.selectedAccountType == .kid
                ) {
                    withAnimation(.spring(duration: 0.3)) {
                        viewModel.selectedAccountType = .kid
                    }
                }

                AccountTypeCard(
                    type: .parent,
                    isSelected: viewModel.selectedAccountType == .parent
                ) {
                    withAnimation(.spring(duration: 0.3)) {
                        viewModel.selectedAccountType = .parent
                    }
                }
            }
            .padding(.horizontal, KiweeTheme.Spacing.screenH)

            Spacer()
        }
    }
}

// MARK: - AccountTypeCard

/// A single tappable account type selection card.
private struct AccountTypeCard: View {
    let type: AccountType
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Text(type.emoji)
                    .font(.system(size: 44))

                VStack(alignment: .leading, spacing: 4) {
                    Text(type.label)
                        .font(.lexend(.headline, weight: .semibold))
                        .foregroundStyle(.primary)

                    Text(subtitle)
                        .font(.figtree(.subheadline, weight: .regular))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundStyle(isSelected ? Color.kiweeGreen : .gray.opacity(0.4))
            }
            .padding(KiweeTheme.Spacing.cardPad)
            .background(
                RoundedRectangle(cornerRadius: KiweeTheme.Radius.card)
                    .fill(Color(.secondarySystemGroupedBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: KiweeTheme.Radius.card)
                    .strokeBorder(
                        isSelected ? Color.kiweeGreen : .clear,
                        lineWidth: 2.5
                    )
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(type.label)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private var subtitle: String {
        switch type {
        case .kid:    "Earn money for chores, set savings goals, and learn to manage your money!"
        case .parent: "Set up allowances, assign chores, and help your kids build smart habits."
        }
    }
}

// MARK: - Preview

#Preview {
    AccountTypeStepView(viewModel: OnboardingViewModel())
}
