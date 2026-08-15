import SwiftUI

// MARK: - FirstGoalStepView

/// Lets the user set their very first savings goal: icon, name, and target amount.
struct FirstGoalStepView: View {
    @Bindable var viewModel: OnboardingViewModel
    @FocusState private var isNameFieldFocused: Bool

    private let iconColumns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Spacer().frame(height: 32)

                // Heading
                Text("🎯")
                    .font(.system(size: 56))
                    .padding(.bottom, 16)

                Text("What are you saving for?")
                    .font(.lexend(.title2, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 8)

                Text("Pick an icon and set a target amount.")
                    .font(.figtree(.body, weight: .regular))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Spacer().frame(height: 32)

                // Icon picker
                LazyVGrid(columns: iconColumns, spacing: 12) {
                    ForEach(GoalIconOption.presets) { icon in
                        GoalIconCell(
                            icon: icon,
                            isSelected: viewModel.selectedGoalIcon.id == icon.id
                        ) {
                            withAnimation(.spring(duration: 0.25)) {
                                viewModel.selectedGoalIcon = icon
                            }
                        }
                    }
                }
                .padding(.horizontal, KiweeTheme.Spacing.screenH)

                Spacer().frame(height: 28)

                // Amount stepper — primary input
                VStack(spacing: 12) {
                    Text("Target amount")
                        .font(.figtree(.subheadline, weight: .medium))
                        .foregroundStyle(.secondary)

                    HStack(spacing: 20) {
                        AmountStepperButton(symbol: "minus") {
                            if viewModel.goalTargetAmount > 5 {
                                viewModel.goalTargetAmount -= 5
                            }
                        }

                        Text("$\(Int(viewModel.goalTargetAmount))")
                            .font(.lexend(size: 36, weight: .bold))
                            .foregroundStyle(Color.kiweeGreen)
                            .frame(minWidth: 100)
                            .contentTransition(.numericText())

                        AmountStepperButton(symbol: "plus") {
                            if viewModel.goalTargetAmount < 500 {
                                viewModel.goalTargetAmount += 5
                            }
                        }
                    }
                }
                .padding(.horizontal, KiweeTheme.Spacing.screenH)

                Spacer().frame(height: 28)

                // Goal name field — optional add-on
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 4) {
                        Text("Goal name")
                            .font(.figtree(.subheadline, weight: .medium))
                            .foregroundStyle(.secondary)
                        Text("(optional)")
                            .font(.figtree(.caption, weight: .regular))
                            .foregroundStyle(.tertiary)
                    }
                    .padding(.leading, 4)

                    TextField("e.g., New skateboard", text: $viewModel.goalName)
                        .font(.figtree(.subheadline, weight: .medium))
                        .textContentType(.none)
                        .autocorrectionDisabled()
                        .focused($isNameFieldFocused)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color(.secondarySystemGroupedBackground))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .strokeBorder(
                                    isNameFieldFocused ? Color.kiweeGreen.opacity(0.5) : .clear,
                                    lineWidth: 1.5
                                )
                        )
                }
                .padding(.horizontal, KiweeTheme.Spacing.screenH)

                Spacer().frame(height: 40)
            }
        }
        .scrollDismissesKeyboard(.interactively)
    }
}

// MARK: - GoalIconCell

private struct GoalIconCell: View {
    let icon: GoalIconOption
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                ZStack {
                    RoundedRectangle(cornerRadius: KiweeTheme.Radius.icon)
                        .fill(isSelected ? Color.kiweeGreen.opacity(0.15) : Color(.tertiarySystemGroupedBackground))
                        .frame(width: 60, height: 60)

                    Image(systemName: icon.symbol)
                        .font(.system(size: 26))
                        .foregroundStyle(isSelected ? Color.kiweeGreen : .secondary)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: KiweeTheme.Radius.icon)
                        .strokeBorder(isSelected ? Color.kiweeGreen : .clear, lineWidth: 2)
                )

                Text(icon.label)
                    .font(.figtree(.caption2, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(isSelected ? .primary : .secondary)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(icon.label)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

// MARK: - AmountStepperButton

private struct AmountStepperButton: View {
    let symbol: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Color.kiweeGreen)
                .frame(width: 48, height: 48)
                .background(
                    Circle()
                        .fill(Color.kiweeGreen.opacity(0.12))
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    FirstGoalStepView(viewModel: OnboardingViewModel())
}
