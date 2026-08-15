import SwiftUI

struct RoleSelectView: View {
    @Environment(AppSession.self) private var session

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Branding
            VStack(spacing: 12) {
                Text("🥝")
                    .font(.system(size: 72))

                Text("Kiwee")
                    .font(.system(size: 36, weight: .bold, design: .rounded))

                Text("Who's using the app?")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            // Role buttons
            VStack(spacing: 14) {
                RoleButton(
                    emoji: "🧒",
                    title: "I'm a Kid",
                    subtitle: "Earn, save & spend",
                    gradientColors: [.pink, .purple]
                ) {
                    session.role = .kid
                }

                RoleButton(
                    emoji: "👨‍👩‍👧",
                    title: "I'm a Parent",
                    subtitle: "Manage family finances",
                    gradientColors: [.blue, .teal]
                ) {
                    session.role = .parent
                }
            }
            .padding(.horizontal, 24)

            Spacer()
                .frame(height: 48)
        }
    }
}

// MARK: - RoleButton

private struct RoleButton: View {
    let emoji: String
    let title: String
    let subtitle: String
    let gradientColors: [Color]
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Text(emoji)
                    .font(.system(size: 32))
                    .frame(width: 52, height: 52)
                    .background(
                        LinearGradient(
                            colors: gradientColors.map { $0.opacity(0.15) },
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        in: RoundedRectangle(cornerRadius: 14)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(16)
            .background(.background, in: RoundedRectangle(cornerRadius: 18))
            .shadow(color: .black.opacity(0.06), radius: 8, y: 2)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    RoleSelectView()
        .environment(AppSession())
}
