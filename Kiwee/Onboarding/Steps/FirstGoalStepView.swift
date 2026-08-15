import SwiftUI

// MARK: - FirstGoalStepView

/// Savings goal setup — dark theme with accent-colored highlights.
struct FirstGoalStepView: View {
    @Bindable var viewModel: OnboardingViewModel
    @FocusState private var isNameFieldFocused: Bool

    private let iconColumns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Spacer().frame(height: 80)

                // Heading
                Text("🎯")
                    .font(.system(size: 56))
                    .padding(.bottom, 16)

                Text("What are you\nsaving for?")
                    .font(.lexend(.title, weight: .bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 8)

                Text("Pick an icon and set a target amount.")
                    .font(.figtree(.body, weight: .regular))
                    .foregroundStyle(.white.opacity(0.5))
                    .multilineTextAlignment(.center)

                Spacer().frame(height: 32)

                // Icon picker
                LazyVGrid(columns: iconColumns, spacing: 12) {
                    ForEach(GoalIconOption.presets) { icon in
                        GoalIconCell(
                            icon: icon,
                            isSelected: viewModel.selectedGoalIcon.id == icon.id,
                            theme: viewModel.theme
                        ) {
                            withAnimation(.spring(duration: 0.25)) {
                                viewModel.selectedGoalIcon = icon
                            }
                        }
                    }
                }
                .padding(.horizontal, KiweeTheme.Spacing.screenH)

                Spacer().frame(height: 28)

                // Amount stepper
                VStack(spacing: 12) {
                    Text("Target amount")
                        .font(.figtree(.subheadline, weight: .medium))
                        .foregroundStyle(.white.opacity(0.5))

                    HStack(spacing: 20) {
                        AmountStepperButton(symbol: "minus", theme: viewModel.theme) {
                            if viewModel.goalTargetAmount > 5 {
                                viewModel.goalTargetAmount -= 5
                            }
                        }

                        Text("$\(Int(viewModel.goalTargetAmount))")
                            .font(.lexend(size: 36, weight: .bold))
                            .foregroundStyle(viewModel.theme.accent)
                            .frame(minWidth: 100)
                            .contentTransition(.numericText())

                        AmountStepperButton(symbol: "plus", theme: viewModel.theme) {
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
                            .foregroundStyle(.white.opacity(0.5))
                        Text("(optional)")
                            .font(.figtree(.caption, weight: .regular))
                            .foregroundStyle(.white.opacity(0.3))
                    }
                    .padding(.leading, 4)

                    TextField("e.g., New skateboard", text: $viewModel.goalName)
                        .font(.figtree(.subheadline, weight: .medium))
                        .foregroundStyle(.white)
                        .textContentType(.none)
                        .autocorrectionDisabled()
                        .focused($isNameFieldFocused)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.white.opacity(0.06))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .strokeBorder(
                                    isNameFieldFocused ? viewModel.theme.accent.opacity(0.5) : Color.white.opacity(0.06),
                                    lineWidth: 1
                                )
                        )
                }
                .padding(.horizontal, KiweeTheme.Spacing.screenH)

                Spacer().frame(height: 100)
            }
        }
        .scrollDismissesKeyboard(.interactively)
    }
}

// MARK: - GoalIconCell

private struct GoalIconCell: View {
    let icon: GoalIconOption
    let isSelected: Bool
    let theme: DynamicTheme
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(isSelected ? theme.accent.opacity(0.15) : Color.white.opacity(0.06))
                        .frame(width: 60, height: 60)

                    Image(systemName: icon.symbol)
                        .font(.system(size: 26))
                        .foregroundStyle(isSelected ? theme.accent : .white.opacity(0.4))
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(isSelected ? theme.accent : .clear, lineWidth: 1.5)
                )

                Text(icon.label)
                    .font(.figtree(.caption2, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(isSelected ? .white : .white.opacity(0.4))
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - AmountStepperButton

private struct AmountStepperButton: View {
    let symbol: String
    let theme: DynamicTheme
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(theme.accent)
                .frame(width: 48, height: 48)
                .background(
                    Circle()
                        .fill(theme.accent.opacity(0.12))
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        OnboardingBackground(theme: DynamicTheme())
        FirstGoalStepView(viewModel: OnboardingViewModel())
    }
    .preferredColorScheme(.dark)
}
