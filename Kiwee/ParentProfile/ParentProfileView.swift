import SwiftUI

struct ParentProfileView: View {
    @Environment(ParentUser.self) private var parent
    @Environment(AppSession.self) private var session

    @State private var isEditingProfile    = false
    @State private var showSignOutSheet    = false
    @State private var navigateToDelete    = false

    var body: some View {
        NavigationStack {
            List {

                // ── HEADER ───────────────────────────────────────────────
                Section {
                    Button {
                        isEditingProfile = true
                    } label: {
                        headerRow
                    }
                    .buttonStyle(.plain)
                    .padding(.vertical, 12)
                    .listRowBackground(
                        LinearGradient(
                            colors: [.blue.opacity(0.18), .teal.opacity(0.12)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                }

                // ── MONEY ────────────────────────────────────────────────
                Section("Money") {
                    NavigationLink {
                        PaymentMethodsView()
                    } label: {
                        Label("Payment Methods", systemImage: "creditcard")
                    }
                    NavigationLink {
                        AutoReloadView()
                    } label: {
                        HStack {
                            Label("Auto-Reload", systemImage: "arrow.clockwise.circle")
                            Spacer()
                            if parent.autoReloadEnabled {
                                Text("On")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    NavigationLink {
                        TransactionHistoryView()
                    } label: {
                        Label("Transaction History", systemImage: "list.bullet.rectangle")
                    }
                }

                // ── FAMILY ───────────────────────────────────────────────
                Section("Family") {
                    NavigationLink {
                        ChildrenView()
                    } label: {
                        HStack {
                            Label("Children", systemImage: "figure.2.and.child.holdinghands")
                            Spacer()
                            Text("\(parent.childrenCount)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    NavigationLink {
                        CoParentView()
                    } label: {
                        Label("Co-Parent", systemImage: "person.2.badge.gearshape")
                    }
                }

                // ── ACCOUNT ──────────────────────────────────────────────
                Section("Account") {
                    NavigationLink {
                        ParentNotificationsView()
                    } label: {
                        Label("Notifications", systemImage: "bell")
                    }
                    NavigationLink {
                        SecurityView()
                    } label: {
                        Label("Security", systemImage: "lock.shield")
                    }
                    NavigationLink {
                        ParentPrivacyView()
                    } label: {
                        Label("Privacy", systemImage: "hand.raised")
                    }
                    NavigationLink {
                        ParentAppearanceView()
                    } label: {
                        Label("Appearance", systemImage: "paintbrush")
                    }
                }

                // ── SUPPORT ──────────────────────────────────────────────
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
                        TermsOfServiceView()
                    } label: {
                        Label("Terms of Service", systemImage: "doc.plaintext")
                    }
                    NavigationLink {
                        PrivacyPolicyView()
                    } label: {
                        Label("Privacy Policy", systemImage: "doc.text")
                    }
                    NavigationLink {
                        AboutKiweeView()
                    } label: {
                        Label("About Kiwee", systemImage: "info.circle")
                    }
                }

                // ── SIGN OUT — standalone, red ────────────────────────────
                Section {
                    Button(role: .destructive) {
                        showSignOutSheet = true
                    } label: {
                        Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }

                // ── VERSION + delete (visually separated, never adjacent) ─
                Section {
                    VStack(spacing: 10) {
                        Text("Kiwee 1.0")
                            .font(.caption)
                            .foregroundStyle(.tertiary)

                        NavigationLink {
                            DeleteAccountView()
                        } label: {
                            Text("Delete account")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
                    .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("Profile")
            .confirmationDialog(
                "Sign out of Kiwee?",
                isPresented: $showSignOutSheet,
                titleVisibility: .visible
            ) {
                Button("Sign Out", role: .destructive) {
                    session.signOut()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("You can sign back in at any time.")
            }
            .sheet(isPresented: $isEditingProfile) {
                EditParentProfileView()
            }
        }
    }

    // MARK: - Header row

    private var headerRow: some View {
        HStack(spacing: 16) {
            // Avatar with seed-color glow
            Circle()
                .fill(
                    LinearGradient(
                        colors: parent.avatarGradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 64, height: 64)
                .overlay {
                    Text(parent.avatarInitials)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }
                .shadow(
                    color: (parent.avatarGradientColors.first ?? .blue).opacity(0.45),
                    radius: 10, y: 4
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(parent.name)
                    .font(.title3.bold())

                Text("Supervising \(parent.childrenCount) \(parent.childrenCount == 1 ? "child" : "children")")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "pencil.circle.fill")
                .font(.title2)
                .foregroundStyle(.tint)
        }
    }
}

// MARK: - Preview

#Preview {
    ParentProfileView()
        .environment(ParentUser.sample)
        .environment(AppSession())
}
