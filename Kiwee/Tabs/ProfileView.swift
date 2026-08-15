import SwiftUI

struct ProfileView: View {
    @Environment(KiweeTheme.self) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        NavigationStack {
            List {
                // Avatar + name
                Section {
                    HStack(spacing: 16) {
                        Circle()
                            .fill(theme.avatar.decorativeGradient)
                            .frame(width: 60, height: 60)
                            .overlay {
                                Text(String(theme.avatar.displayName.prefix(1)))
                                    .font(.kiwee(.heading2))
                                    .foregroundStyle(KiweeColor.textPrimary)
                            }
                            .kiweeGlow(radius: 16, intensity: .medium)

                        VStack(alignment: .leading, spacing: 4) {
                            // User name — Lexend (spec §18: avatar name)
                            Text("Kiwee Kid")
                                .font(.lexend(size: 18, weight: .semibold))
                                .foregroundStyle(KiweeColor.textPrimary)
                            // Membership — Figtree (spec §18: personality description)
                            Text("Member since 2025")
                                .font(.kiwee(.labelMedium))
                                .foregroundStyle(KiweeColor.textSecondary)
                        }
                    }
                    .padding(.vertical, 8)
                }

                // Avatar picker
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(KiweeAvatar.allCases) { avatar in
                                Button {
                                    if reduceMotion {
                                        theme.avatar = avatar
                                    } else {
                                        withAnimation(.easeOut(duration: 0.2)) {
                                            theme.avatar = avatar
                                        }
                                    }
                                } label: {
                                    VStack(spacing: 6) {
                                        Circle()
                                            .fill(avatar.scale.hero)
                                            .frame(width: 44, height: 44)
                                            .overlay {
                                                Text(String(avatar.displayName.prefix(1)))
                                                    .font(.lexend(size: 16, weight: .bold))
                                                    .foregroundStyle(
                                                        KiweeContrast.accessibleForeground(on: avatar.scale.hero)
                                                    )
                                            }
                                            .overlay {
                                                if theme.avatar == avatar {
                                                    Circle()
                                                        .strokeBorder(KiweeColor.textPrimary, lineWidth: 2.5)
                                                }
                                            }

                                        // Avatar name — Figtree (utility label)
                                        Text(avatar.displayName)
                                            .font(.kiwee(.labelSmall))
                                            .foregroundStyle(
                                                theme.avatar == avatar
                                                    ? KiweeColor.textPrimary
                                                    : KiweeColor.textTertiary
                                            )
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 4)
                        .padding(.vertical, 8)
                    }
                } header: {
                    Text("Your Kiwee")
                        .font(.kiwee(.overline))
                }

                Section {
                    // Settings items — Inter (information layer, spec §4)
                    Label("Notifications", systemImage: "bell")
                        .font(.kiwee(.bodyMedium))
                    Label("Privacy", systemImage: "lock")
                        .font(.kiwee(.bodyMedium))
                    Label("Appearance", systemImage: "paintbrush")
                        .font(.kiwee(.bodyMedium))
                    Label("Family", systemImage: "person.2")
                        .font(.kiwee(.bodyMedium))
                } header: {
                    Text("Account")
                        .font(.kiwee(.overline))
                }

                Section {
                    Label("Help Center", systemImage: "questionmark.circle")
                        .font(.kiwee(.bodyMedium))
                    Label("Send Feedback", systemImage: "envelope")
                        .font(.kiwee(.bodyMedium))
                    Label("About Kiwee", systemImage: "info.circle")
                        .font(.kiwee(.bodyMedium))
                } header: {
                    Text("Support")
                        .font(.kiwee(.overline))
                }
            }
            .navigationTitle("Profile")
        }
    }
}
