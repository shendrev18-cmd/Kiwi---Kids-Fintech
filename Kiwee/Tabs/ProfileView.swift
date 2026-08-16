import SwiftUI

struct ProfileView: View {
    @Environment(User.self) private var user
    @Environment(AppSession.self) private var session

    @Binding var selectedTab: KiweeTab

    @State private var isEditingProfile   = false
    @State private var showSignOutConfirm = false

    var body: some View {
        NavigationStack {
            List {
                // ── Hero ──────────────────────────────────────────────────
                Section {
                    heroSection
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .listRowBackground(
                            LinearGradient(
                                colors: [.pink.opacity(0.2), .purple.opacity(0.15)],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                        .listRowInsets(EdgeInsets())
                }

                // ── Stats — tappable → Activity tab ───────────────────────
                Section {
                    HStack(spacing: 0) {
                        StatCell(
                            icon: "dollarsign.circle.fill", color: .green,
                            value: user.totalEarned.formatted(.currency(code: "USD")),
                            label: "Earned"
                        ) { selectedTab = .activity }

                        Divider().frame(maxHeight: 44)

                        StatCell(
                            icon: "target", color: .purple,
                            value: user.totalSaved.formatted(.currency(code: "USD")),
                            label: "Saved"
                        ) { selectedTab = .activity }

                        Divider().frame(maxHeight: 44)

                        StatCell(
                            icon: "checkmark.circle.fill", color: .orange,
                            value: "\(user.choresCompleted)",
                            label: "Chores"
                        ) { selectedTab = .activity }
                    }
                    .padding(.vertical, 8)
                }

                // ── Account ───────────────────────────────────────────────
                Section("Account") {
                    NavigationLink { NotificationsSettingsView() } label: {
                        Label("Notifications", systemImage: "bell")
                    }
                    NavigationLink { KidSecurityView() } label: {
                        Label("Security", systemImage: "lock.shield")
                    }
                    NavigationLink { PrivacySettingsView() } label: {
                        Label("Privacy", systemImage: "lock")
                    }
                    NavigationLink { AppearanceSettingsView() } label: {
                        Label("Appearance", systemImage: "paintbrush")
                    }
                    NavigationLink { KidFamilyView() } label: {
                        Label("Family", systemImage: "person.2")
                    }
                }

                // ── Support ───────────────────────────────────────────────
                Section("Support") {
                    NavigationLink { HelpCenterView() } label: {
                        Label("Help Center", systemImage: "questionmark.circle")
                    }
                    NavigationLink { SendFeedbackView() } label: {
                        Label("Send Feedback", systemImage: "envelope")
                    }
                    NavigationLink { TermsOfServiceView() } label: {
                        Label("Terms of Service", systemImage: "doc.plaintext")
                    }
                    NavigationLink { PrivacyPolicyView() } label: {
                        Label("Privacy Policy", systemImage: "doc.text")
                    }
                    NavigationLink { AboutKiweeView() } label: {
                        Label("About Kiwee", systemImage: "info.circle")
                    }
                }

                // ── Sign out — standalone red section ─────────────────────
                Section {
                    Button(role: .destructive) {
                        showSignOutConfirm = true
                    } label: {
                        Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationTitle("Profile")
            .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 80) }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit") { isEditingProfile = true }
                }
            }
            .sheet(isPresented: $isEditingProfile) {
                EditProfileView()
            }
            .confirmationDialog(
                "Sign out of Kiwee?",
                isPresented: $showSignOutConfirm,
                titleVisibility: .visible
            ) {
                Button("Sign Out", role: .destructive) { session.signOut() }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("You can sign back in at any time.")
            }
        }
    }

    // MARK: - Hero

    private var heroSection: some View {
        VStack(spacing: 16) {
            // Avatar — gradient circle, initials, never "?"
            Circle()
                .fill(LinearGradient(
                    colors: user.avatarGradientColors,
                    startPoint: .topLeading, endPoint: .bottomTrailing
                ))
                .frame(width: 96, height: 96)
                .overlay {
                    let initials = user.avatarInitials.isEmpty ? user.name.prefix(1).uppercased() : user.avatarInitials
                    Text(initials)
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }
                .shadow(color: (user.avatarGradientColors.last ?? .purple).opacity(0.4), radius: 10, y: 4)

            VStack(spacing: 4) {
                Text(user.name)
                    .font(.title2.bold())
                HStack(spacing: 6) {
                    Text(user.accountType.emoji)
                    Text("·").foregroundStyle(.tertiary)
                    Text("Since \(user.memberSince.formatted(.dateTime.year()))")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            // Level badge
            let lvl = user.level
            let progress: Double = {
                guard let next = lvl.nextLevelXP else { return 1.0 }
                let range = next - lvl.minXP
                guard range > 0 else { return 1.0 }
                return Double(user.xp - lvl.minXP) / Double(range)
            }()

            VStack(spacing: 8) {
                HStack(spacing: 6) {
                    Text(lvl.emoji)
                    Text(lvl.label).font(.caption.weight(.semibold))
                    Spacer()
                    Text("\(user.xp) XP").font(.caption.weight(.medium)).foregroundStyle(.secondary)
                }
                .padding(.horizontal, 14).padding(.vertical, 7)
                .background(lvl.color.opacity(0.15), in: Capsule())

                ProgressView(value: progress)
                    .tint(lvl.color)
                    .scaleEffect(x: 1, y: 1.5)
            }
            .padding(.horizontal, 32)
        }
    }
}

// MARK: - StatCell

private struct StatCell: View {
    let icon: String
    let color: Color
    let value: String
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon).font(.title3).foregroundStyle(color)
                Text(value).font(.system(.subheadline, design: .rounded, weight: .bold))
                Text(label).font(.caption2).foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    ProfileView(selectedTab: .constant(.profile))
        .environment(User.sample)
        .environment(AppSession())
}
