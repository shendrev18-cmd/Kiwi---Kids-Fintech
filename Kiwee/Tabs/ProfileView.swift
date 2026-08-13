import SwiftUI

struct ProfileView: View {
    @Environment(User.self) private var user
    @State private var isEditingProfile = false

    var body: some View {
        NavigationStack {
            List {
                // MARK: Hero
                Section {
                    heroSection
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .listRowBackground(
                            LinearGradient(
                                colors: [.pink.opacity(0.2), .purple.opacity(0.15)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .listRowInsets(EdgeInsets())
                }

                // MARK: Stats
                Section {
                    HStack(spacing: 0) {
                        StatCell(
                            icon: "dollarsign.circle.fill",
                            color: .green,
                            value: user.totalEarned.formatted(.currency(code: "USD")),
                            label: "Earned"
                        )
                        Divider()
                            .frame(maxHeight: 44)
                        StatCell(
                            icon: "target",
                            color: .purple,
                            value: user.totalSaved.formatted(.currency(code: "USD")),
                            label: "Saved"
                        )
                        Divider()
                            .frame(maxHeight: 44)
                        StatCell(
                            icon: "checkmark.circle.fill",
                            color: .orange,
                            value: "\(user.choresCompleted)",
                            label: "Chores"
                        )
                    }
                    .padding(.vertical, 8)
                }

                // MARK: Account
                Section("Account") {
                    NavigationLink {
                        NotificationsSettingsView()
                    } label: {
                        Label("Notifications", systemImage: "bell")
                    }
                    NavigationLink {
                        PrivacySettingsView()
                    } label: {
                        Label("Privacy", systemImage: "lock")
                    }
                    NavigationLink {
                        AppearanceSettingsView()
                    } label: {
                        Label("Appearance", systemImage: "paintbrush")
                    }
                    NavigationLink {
                        FamilyView()
                    } label: {
                        Label("Family", systemImage: "person.2")
                    }
                }

                // MARK: Support
                Section("Support") {
                    NavigationLink {
                        HelpCenterView()
                    } label: {
                        Label("Help Center", systemImage: "questionmark.circle")
                    }
                    NavigationLink {
                        SendFeedbackView()
                    } label: {
                        Label("Send Feedback", systemImage: "envelope")
                    }
                    NavigationLink {
                        AboutKiweeView()
                    } label: {
                        Label("About Kiwee", systemImage: "info.circle")
                    }
                }
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit") {
                        isEditingProfile = true
                    }
                }
            }
            .sheet(isPresented: $isEditingProfile) {
                EditProfileView()
            }
        }
    }

    // MARK: - Hero Section

    private var heroSection: some View {
        VStack(spacing: 16) {
            // Avatar
            Circle()
                .fill(
                    LinearGradient(
                        colors: user.avatarGradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 96, height: 96)
                .overlay {
                    Text(user.avatarInitials)
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }
                .shadow(color: (user.avatarGradientColors.last ?? .purple).opacity(0.4), radius: 10, y: 4)

            // Name + account info
            VStack(spacing: 4) {
                Text(user.name)
                    .font(.title2.bold())

                HStack(spacing: 6) {
                    Text(user.accountType.emoji)
                    Text("·")
                        .foregroundStyle(.tertiary)
                    Text("Since \(user.memberSince.formatted(.dateTime.year()))")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            // Level badge
            levelBadgeView
        }
    }

    // MARK: - Level Badge

    private var levelBadgeView: some View {
        let lvl = user.level
        let progress: Double = {
            guard let nextXP = lvl.nextLevelXP else { return 1.0 }
            let range = nextXP - lvl.minXP
            guard range > 0 else { return 1.0 }
            return Double(user.xp - lvl.minXP) / Double(range)
        }()

        return VStack(spacing: 8) {
            // Pill
            HStack(spacing: 6) {
                Text(lvl.emoji)
                Text(lvl.label)
                    .font(.caption.weight(.semibold))
                Spacer()
                Text("\(user.xp) XP")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background(lvl.color.opacity(0.15), in: Capsule())

            // Progress bar
            ProgressView(value: progress)
                .tint(lvl.color)
                .scaleEffect(x: 1, y: 1.5)
        }
        .padding(.horizontal, 32)
    }
}

// MARK: - StatCell

private struct StatCell: View {
    let icon: String
    let color: Color
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
            Text(value)
                .font(.system(.subheadline, design: .rounded, weight: .bold))
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview

#Preview {
    ProfileView()
        .environment(User.sample)
}
