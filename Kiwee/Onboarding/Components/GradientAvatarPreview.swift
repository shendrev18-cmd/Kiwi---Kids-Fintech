import SwiftUI

// MARK: - GradientAvatarPreview

/// Circular avatar with a gradient background and initials overlay.
/// Used in the avatar picker step and the celebration step.
struct GradientAvatarPreview: View {
    let initials: String
    let gradientColors: [Color]
    var size: CGFloat = 120

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
                .shadow(color: gradientColors.first?.opacity(0.4) ?? .clear, radius: 16, y: 8)

            Text(initials)
                .font(.lexend(size: size * 0.35, weight: .bold))
                .foregroundStyle(.white)
        }
    }
}

// MARK: - Preview

#Preview {
    HStack(spacing: 20) {
        GradientAvatarPreview(initials: "KK", gradientColors: [.pink, .purple])
        GradientAvatarPreview(initials: "AJ", gradientColors: [.blue, .teal], size: 80)
        GradientAvatarPreview(initials: "M", gradientColors: [.green, .mint], size: 60)
    }
}
