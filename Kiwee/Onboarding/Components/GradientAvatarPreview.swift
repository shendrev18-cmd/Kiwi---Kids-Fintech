import SwiftUI

// MARK: - GradientAvatarPreview

/// Circular avatar with a gradient background and emoji or initials overlay.
/// Used in the avatar picker step and the celebration step.
struct GradientAvatarPreview: View {
    let emoji: String
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
                .shadow(color: gradientColors.last?.opacity(0.5) ?? .clear, radius: size * 0.15, y: size * 0.06)

            Text(emoji)
                .font(.system(size: size * 0.45))
        }
    }
}

// MARK: - Preview

#Preview {
    HStack(spacing: 20) {
        GradientAvatarPreview(emoji: "🚀", gradientColors: [Color(red: 0.15, green: 0.25, blue: 0.55), Color(red: 0.30, green: 0.50, blue: 0.95)])
        GradientAvatarPreview(emoji: "🦖", gradientColors: [Color(red: 0.12, green: 0.40, blue: 0.18), Color(red: 0.30, green: 0.80, blue: 0.40)], size: 80)
        GradientAvatarPreview(emoji: "🧙", gradientColors: [Color(red: 0.28, green: 0.15, blue: 0.50), Color(red: 0.55, green: 0.35, blue: 0.90)], size: 60)
    }
    .preferredColorScheme(.dark)
}
