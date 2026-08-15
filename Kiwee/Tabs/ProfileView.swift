import SwiftUI

struct ProfileView: View {
    @Environment(User.self) private var user

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 16) {
                        // User's avatar — emoji on gradient circle
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: user.avatarGradientColors,
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 60, height: 60)

                            Text(user.avatarEmoji)
                                .font(.system(size: 30))
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.name)
                                .font(.lexend(.title3, weight: .bold))

                            HStack(spacing: 6) {
                                Text(user.level.emoji)
                                Text(user.level.label)
                                    .font(.figtree(.caption, weight: .medium))
                                    .foregroundStyle(user.level.color)
                            }

                            Text("\(user.accountType.label) · Member since \(user.memberSince.formatted(.dateTime.year()))")
                                .font(.figtree(.caption, weight: .regular))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }

                // Stats row
                Section {
                    HStack {
                        StatItem(label: "Earned", value: "$\(String(format: "%.0f", user.totalEarned))", color: user.accentColor)
                        Spacer()
                        StatItem(label: "Saved", value: "$\(String(format: "%.0f", user.totalSaved))", color: .purple)
                        Spacer()
                        StatItem(label: "Chores", value: "\(user.choresCompleted)", color: .orange)
                    }
                    .padding(.vertical, 4)
                }

                Section("Account") {
                    Label("Notifications", systemImage: "bell")
                    Label("Privacy", systemImage: "lock")
                    Label("Family", systemImage: "person.2")
                }

                Section("Support") {
                    Label("Help Center", systemImage: "questionmark.circle")
                    Label("Send Feedback", systemImage: "envelope")
                    Label("About Kiwee", systemImage: "info.circle")
                }
            }
            .navigationTitle("Profile")
        }
    }
}

// MARK: - StatItem

private struct StatItem: View {
    let label: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.lexend(.headline, weight: .bold))
                .foregroundStyle(color)
            Text(label)
                .font(.figtree(.caption2, weight: .medium))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview

#Preview {
    ProfileView()
        .environment(User.sample)
        .preferredColorScheme(.dark)
}
