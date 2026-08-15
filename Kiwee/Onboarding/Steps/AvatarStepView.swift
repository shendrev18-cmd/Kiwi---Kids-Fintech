import SwiftUI

// MARK: - AvatarStepView

/// Grid of emoji character avatars. Selecting one changes the app's accent color
/// and the entire screen's gradient animates to match.
struct AvatarStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 5)

    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 80)

            // Live preview of selected avatar
            GradientAvatarPreview(
                emoji: viewModel.selectedAvatar.emoji,
                gradientColors: [viewModel.theme.glowMid, viewModel.theme.glowWarm],
                size: 120
            )
            .padding(.bottom, 12)

            Text(viewModel.userName.isEmpty ? "Choose your avatar" : viewModel.userName)
                .font(.lexend(.title3, weight: .bold))
                .foregroundStyle(.white)
                .padding(.bottom, 4)

            Text("Pick a character — it sets your style!")
                .font(.figtree(.subheadline, weight: .regular))
                .foregroundStyle(.white.opacity(0.5))

            Spacer().frame(height: 32)

            // Avatar grid
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(AvatarOption.presets) { avatar in
                    AvatarPickerCell(
                        avatar: avatar,
                        isSelected: viewModel.selectedAvatar.id == avatar.id,
                        theme: viewModel.theme
                    ) {
                        viewModel.selectedAvatar = avatar
                    }
                }
            }
            .padding(.horizontal, KiweeTheme.Spacing.screenH)

            Spacer()
        }
        .animation(.easeOut(duration: 0.4), value: viewModel.selectedAvatar.id)
    }
}

// MARK: - AvatarPickerCell

/// A single tappable emoji avatar in the grid.
private struct AvatarPickerCell: View {
    let avatar: AvatarOption
    let isSelected: Bool
    let theme: DynamicTheme
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                ZStack {
                    // Background circle — uses the avatar's own seed color when selected
                    Circle()
                        .fill(
                            isSelected
                            ? LinearGradient(
                                colors: [theme.glowMid, theme.glowWarm],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                              )
                            : LinearGradient(
                                colors: [Color.white.opacity(0.08), Color.white.opacity(0.04)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                              )
                        )
                        .frame(width: 56, height: 56)

                    // Selection ring
                    if isSelected {
                        Circle()
                            .strokeBorder(theme.accent, lineWidth: 2.5)
                            .frame(width: 56, height: 56)
                    }

                    Text(avatar.emoji)
                        .font(.system(size: 28))
                }
                .scaleEffect(isSelected ? 1.1 : 1.0)

                Text(avatar.label)
                    .font(.figtree(.caption2, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(isSelected ? .white : .white.opacity(0.5))
                    .lineLimit(1)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(avatar.label)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        OnboardingBackground(theme: DynamicTheme())
        AvatarStepView(viewModel: {
            let vm = OnboardingViewModel()
            vm.userName = "Alex"
            return vm
        }())
    }
    .preferredColorScheme(.dark)
}
