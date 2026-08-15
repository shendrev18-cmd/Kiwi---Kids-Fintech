import SwiftUI

struct CoParentView: View {
    @Environment(ParentUser.self) private var parent
    @State private var showInviteSheet = false

    var body: some View {
        List {
            if parent.coParents.isEmpty {
                Section {
                    ContentUnavailableView(
                        "No co-parent yet",
                        systemImage: "person.2.badge.gearshape",
                        description: Text("Invite another guardian to help manage your family's finances.")
                    )
                }
            } else {
                Section {
                    ForEach(parent.coParents) { coParent in
                        CoParentRow(coParent: coParent) { newLevel in
                            updateAccess(id: coParent.id, newLevel: newLevel)
                        } onRevoke: {
                            parent.coParents.removeAll { $0.id == coParent.id }
                        }
                    }
                } header: {
                    Text("Guardians")
                } footer: {
                    Text("Co-parents with Full Access can approve chores and send allowance. View Only guardians can see activity but cannot take action.")
                }
            }

            Section {
                Button {
                    showInviteSheet = true
                } label: {
                    Label("Invite Co-Parent", systemImage: "person.badge.plus")
                }
            }
        }
        .navigationTitle("Co-Parent")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showInviteSheet) {
            InviteCoParentView()
        }
    }

    private func updateAccess(id: UUID, newLevel: CoParentAccess) {
        guard let i = parent.coParents.firstIndex(where: { $0.id == id }) else { return }
        parent.coParents[i].accessLevel = newLevel
    }
}

// MARK: - CoParentRow

private struct CoParentRow: View {
    let coParent: CoParent
    let onChangeAccess: (CoParentAccess) -> Void
    let onRevoke: () -> Void

    @State private var showOptions = false

    var body: some View {
        HStack(spacing: 14) {
            Circle()
                .fill(LinearGradient(colors: [.blue, .teal], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 44, height: 44)
                .overlay {
                    Text(initials(from: coParent.name))
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(coParent.name)
                        .font(.subheadline.weight(.medium))
                    if coParent.isAccepted {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(.green)
                            .font(.caption)
                    } else {
                        Text("Pending")
                            .font(.caption2.weight(.semibold))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.orange.opacity(0.15), in: Capsule())
                            .foregroundStyle(.orange)
                    }
                }
                Text(coParent.accessLevel.rawValue)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture { showOptions = true }
        .confirmationDialog(coParent.name, isPresented: $showOptions, titleVisibility: .visible) {
            ForEach(CoParentAccess.allCases, id: \.rawValue) { level in
                Button(level.rawValue) { onChangeAccess(level) }
            }
            Button("Revoke Access", role: .destructive) { onRevoke() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Change access level or revoke co-parent access.")
        }
    }

    private func initials(from name: String) -> String {
        name.split(separator: " ")
            .prefix(2)
            .compactMap(\.first)
            .map(String.init)
            .joined()
            .uppercased()
    }
}

// MARK: - InviteCoParentView

private struct InviteCoParentView: View {
    @Environment(ParentUser.self) private var parent
    @Environment(\.dismiss) private var dismiss

    @State private var name  = ""
    @State private var email = ""
    @State private var accessLevel: CoParentAccess = .full

    private var canInvite: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !email.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Guardian's Details") {
                    TextField("Full name", text: $name)
                        .autocorrectionDisabled()
                    TextField("Email address", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }

                Section {
                    Picker("Access Level", selection: $accessLevel) {
                        ForEach(CoParentAccess.allCases, id: \.rawValue) { level in
                            Label(level.rawValue, systemImage: level.icon).tag(level)
                        }
                    }
                    .pickerStyle(.menu)
                } header: {
                    Text("Permissions")
                } footer: {
                    Text(accessLevel == .full
                         ? "Can approve chores, send allowance, and manage settings."
                         : "Can view activity and balances, but cannot take action.")
                }
            }
            .navigationTitle("Invite Co-Parent")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading)  { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Send Invite") {
                        parent.coParents.append(CoParent(
                            id: UUID(),
                            name: name.trimmingCharacters(in: .whitespaces),
                            email: email.trimmingCharacters(in: .whitespaces),
                            accessLevel: accessLevel,
                            isAccepted: false
                        ))
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(!canInvite)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        CoParentView()
            .environment(ParentUser.sample)
    }
}
