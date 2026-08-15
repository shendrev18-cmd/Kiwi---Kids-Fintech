import SwiftUI

struct ChildrenView: View {
    @Environment(ParentUser.self) private var parent

    @State private var showAddChild    = false
    @State private var childToRemove: ChildAccount? = nil
    @State private var childForCode:  ChildAccount? = nil

    var body: some View {
        List {
            Section {
                ForEach(parent.children) { child in
                    ChildRow(
                        child: child,
                        onTogglePause: { togglePause(child: child) },
                        onGenerateCode: { childForCode = child },
                        onRemove: { childToRemove = child }
                    )
                }
            } header: {
                Text("Children (\(parent.children.count))")
            }

            Section {
                Button {
                    showAddChild = true
                } label: {
                    Label("Add Child", systemImage: "person.badge.plus")
                }
            }
        }
        .navigationTitle("Children")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAddChild) {
            AddChildView()
        }
        .sheet(item: $childToRemove) { child in
            RemoveChildView(child: child) {
                parent.children.removeAll { $0.id == child.id }
            }
        }
        .sheet(item: $childForCode) { child in
            InviteCodeView(childName: child.name)
        }
    }

    private func togglePause(child: ChildAccount) {
        guard let index = parent.children.firstIndex(where: { $0.id == child.id }) else { return }
        parent.children[index].isPaused.toggle()
    }
}

// MARK: - ChildRow

private struct ChildRow: View {
    let child: ChildAccount
    let onTogglePause: () -> Void
    let onGenerateCode: () -> Void
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [child.gradientStart, child.gradientEnd],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 44, height: 44)
                .overlay {
                    Text(child.initials)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(child.name)
                        .font(.subheadline.weight(.medium))
                    if child.isPaused {
                        Text("Paused")
                            .font(.caption2.weight(.semibold))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.orange.opacity(0.15), in: Capsule())
                            .foregroundStyle(.orange)
                    }
                }
                Text("Balance: \(child.balance, format: .currency(code: "USD"))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 4)
        .contextMenu {
            Button {
                onTogglePause()
            } label: {
                Label(child.isPaused ? "Resume Access" : "Pause Access",
                      systemImage: child.isPaused ? "play.circle" : "pause.circle")
            }

            Button {
                onGenerateCode()
            } label: {
                Label("Invite Code", systemImage: "qrcode")
            }

            Divider()

            Button(role: .destructive) {
                onRemove()
            } label: {
                Label("Remove Child…", systemImage: "person.badge.minus")
            }
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                onRemove()
            } label: {
                Label("Remove", systemImage: "person.badge.minus")
            }

            Button {
                onTogglePause()
            } label: {
                Label(child.isPaused ? "Resume" : "Pause", systemImage: child.isPaused ? "play.circle" : "pause.circle")
            }
            .tint(.orange)
        }
    }
}

// MARK: - RemoveChildView  (acceptance: must type the child's name)

struct RemoveChildView: View {
    let child: ChildAccount
    let onConfirm: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var confirmationText = ""

    private var nameMatches: Bool {
        confirmationText.trimmingCharacters(in: .whitespaces)
            .caseInsensitiveCompare(child.name) == .orderedSame
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        Label("This will permanently remove \(child.name) from your family account.", systemImage: "exclamationmark.triangle.fill")
                            .foregroundStyle(.red)
                            .font(.subheadline)

                        Text("Their balance and transaction history will be deleted and cannot be recovered.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                    .listRowBackground(Color.red.opacity(0.05))
                }

                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Type **\(child.name)** to confirm")
                            .font(.subheadline)
                        TextField("Child's name", text: $confirmationText)
                            .autocorrectionDisabled()
                    }
                } footer: {
                    Text("The name must match exactly.")
                }

                Section {
                    Button(role: .destructive) {
                        onConfirm()
                        dismiss()
                    } label: {
                        Text("Remove \(child.name)")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .disabled(!nameMatches)
                }
            }
            .navigationTitle("Remove Child")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

// MARK: - AddChildView

private struct AddChildView: View {
    @Environment(ParentUser.self) private var parent
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""

    private let colorOptions: [(Color, Color)] = [
        (.pink, .purple), (.blue, .teal), (.green, .mint), (.orange, .yellow)
    ]
    @State private var selectedColors: (Color, Color) = (.pink, .purple)

    private var canAdd: Bool { !name.trimmingCharacters(in: .whitespaces).isEmpty }

    var body: some View {
        NavigationStack {
            List {
                Section("Child's Name") {
                    TextField("First name or nickname", text: $name)
                        .autocorrectionDisabled()
                }
                Section("Avatar Color") {
                    HStack(spacing: 16) {
                        ForEach(colorOptions.indices, id: \.self) { i in
                            let option = colorOptions[i]
                            Circle()
                                .fill(LinearGradient(colors: [option.0, option.1], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 40, height: 40)
                                .overlay {
                                    if selectedColors.0 == option.0 {
                                        Image(systemName: "checkmark")
                                            .font(.caption.weight(.bold))
                                            .foregroundStyle(.white)
                                    }
                                }
                                .onTapGesture { selectedColors = option }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Add Child")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading)  { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        let trimmed = name.trimmingCharacters(in: .whitespaces)
                        let initials = trimmed.split(separator: " ")
                            .prefix(2).compactMap(\.first).map(String.init).joined().uppercased()
                        parent.children.append(ChildAccount(
                            id: UUID(),
                            name: trimmed,
                            initials: initials.isEmpty ? String(trimmed.prefix(1)).uppercased() : initials,
                            gradientStart: selectedColors.0,
                            gradientEnd: selectedColors.1,
                            isPaused: false,
                            balance: 0,
                            choresCompleted: 0
                        ))
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(!canAdd)
                }
            }
        }
    }
}

// MARK: - InviteCodeView

private struct InviteCodeView: View {
    let childName: String
    @Environment(\.dismiss) private var dismiss

    // Simple 6-char alphanumeric code — static per session (no real auth backend)
    @State private var code = InviteCodeView.generateCode()
    @State private var copied = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()

                VStack(spacing: 12) {
                    Text("Invite Code for \(childName)")
                        .font(.headline)
                        .multilineTextAlignment(.center)

                    Text(code)
                        .font(.system(size: 40, weight: .bold, design: .monospaced))
                        .tracking(8)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 20)
                        .background(.secondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))
                }

                Button {
                    UIPasteboard.general.string = code
                    copied = true
                } label: {
                    Label(copied ? "Copied!" : "Copy Code", systemImage: copied ? "checkmark.circle.fill" : "doc.on.doc")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.tint.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal, 32)
                .animation(.default, value: copied)

                Button {
                    code = InviteCodeView.generateCode()
                    copied = false
                } label: {
                    Label("Generate New Code", systemImage: "arrow.clockwise")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Text("This code expires in 24 hours. Share it with \(childName) to link their device.")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                Spacer()
            }
            .navigationTitle("Invite Code")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
        }
    }

    private static func generateCode() -> String {
        let chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
        return String((0..<6).compactMap { _ in chars.randomElement() })
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ChildrenView()
            .environment(ParentUser.sample)
    }
}
