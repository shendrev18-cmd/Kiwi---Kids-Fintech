import SwiftUI

/// Multi-step destructive flow: warning → password confirmation → account cleared.
/// Visually distinct from Sign Out and never placed adjacent to it.
struct DeleteAccountView: View {
    @Environment(AppSession.self) private var session
    @Environment(ParentUser.self) private var parent
    @Environment(\.dismiss) private var dismiss

    @State private var password = ""
    @State private var showFinalConfirm = false

    private var canProceed: Bool {
        !password.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        List {
            // ── Warning card ─────────────────────────────────────────────
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 10) {
                        Image(systemName: "exclamationmark.octagon.fill")
                            .font(.title2)
                            .foregroundStyle(.red)
                        Text("This cannot be undone")
                            .font(.headline)
                            .foregroundStyle(.red)
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        BulletRow("Your account and all data will be permanently deleted.")
                        BulletRow("All \(parent.children.count) child \(parent.children.count == 1 ? "account" : "accounts") will be removed.")
                        BulletRow("Transaction history cannot be recovered.")
                        BulletRow("Any remaining balance will be forfeited.")
                    }
                }
                .padding(.vertical, 6)
                .listRowBackground(Color.red.opacity(0.06))
            }

            // ── Password confirmation ─────────────────────────────────────
            Section {
                SecureField("Enter your password to confirm", text: $password)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            } header: {
                Text("Confirm your identity")
            } footer: {
                Text("Your password is required to authorize account deletion.")
            }

            // ── Destructive button ─────────────────────────────────────────
            Section {
                Button(role: .destructive) {
                    showFinalConfirm = true
                } label: {
                    Text("Permanently Delete Account")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .fontWeight(.semibold)
                }
                .disabled(!canProceed)
            }
        }
        .navigationTitle("Delete Account")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog(
            "Delete account permanently?",
            isPresented: $showFinalConfirm,
            titleVisibility: .visible
        ) {
            Button("Delete Account", role: .destructive) {
                // Clear session — simulates full account erasure
                session.signOut()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This is permanent. Child accounts and all data will be erased immediately.")
        }
    }
}

// MARK: - BulletRow

private struct BulletRow: View {
    let text: String
    init(_ text: String) { self.text = text }

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .foregroundStyle(.red)
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        DeleteAccountView()
            .environment(AppSession())
            .environment(ParentUser.sample)
    }
}
