import SwiftUI

// MARK: - AvatarStepView

/// Lets the user pick a gradient color pair for their avatar circle.
struct AvatarStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 4)

    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 32)

            // Live preview
            GradientAvatarPreview(
                initials: viewModel.avatarInitials,
                gradientColors: viewModel.selectedGradient.colors,
                size: 120
            )
            .padding(.bottom, 8)

            Text(viewModel.userName.isEmpty ? "Your Avatar" : viewModel.userName)
                .font(.lexend(.title3, weight: .semibold))
                .padding(.bottom, 4)

            Text("Pick your favorite colors")
                .font(.figtree(.subheadline, weight: .regular))
                .foregroundStyle(.secondary)

            Spacer().frame(height: 36)

            // Color grid
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(AvatarGradientOption.presets) { option in
                    GradientPickerCell(
                        option: option,
                        isSelected: viewModel.selectedGradient.id == option.id
                    ) {
                        withAnimation(.spring(duration: 0.3)) {
                            viewModel.selectedGradient = option
                        }
                    }
                }
            }
            .padding(.horizontal, KiweeTheme.Spacing.screenH)

            Spacer()
        }
    }
}

// MARK: - GradientPickerCell

/// A single tappable gradient circle in the avatar color picker grid.
private struct GradientPickerCell: View {
    let option: AvatarGradientOption
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: option.colors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 56, height: 56)

                    if isSelected {
                        Circle()
                            .strokeBorder(.white, lineWidth: 3)
                            .frame(width: 56, height: 56)

                        Image(systemName: "checkmark")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
                .shadow(color: option.colors.first?.opacity(0.3) ?? .clear, radius: isSelected ? 8 : 4, y: 4)
                .scaleEffect(isSelected ? 1.1 : 1.0)

                Text(option.label)
                    .font(.figtree(.caption, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(isSelected ? .primary : .secondary)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(option.label) gradient")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

// MARK: - Preview

#Preview {
    AvatarStepView(viewModel: {
        let vm = OnboardingViewModel()
        vm.userName = "Alex"
        return vm
    }())
}
