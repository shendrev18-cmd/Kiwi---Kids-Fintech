import SwiftUI

struct KidSecurityView: View {
    @Environment(User.self) private var user
    @State private var showChangePIN = false

    var body: some View {
        @Bindable var user = user

        List {
            Section {
                Button {
                    showChangePIN = true
                } label: {
                    HStack {
                        Label(user.hasPIN ? "Change PIN" : "Set PIN", systemImage: "lock.rotation")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.tertiary)
                    }
                }
                .foregroundStyle(.primary)

                Toggle(isOn: $user.biometricEnabled) {
                    Label("Face ID / Touch ID", systemImage: "faceid")
                }
            } header: {
                Text("Authentication")
            } footer: {
                Text("Use biometrics to sign in quickly without typing your PIN.")
            }
        }
        .navigationTitle("Security")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showChangePIN) {
            KidChangePINView()
        }
    }
}

// MARK: - KidChangePINView

private struct KidChangePINView: View {
    @Environment(User.self) private var user
    @Environment(\.dismiss) private var dismiss

    @State private var currentPIN  = ""
    @State private var newPIN      = ""
    @State private var confirmPIN  = ""
    @State private var errorMessage: String?

    private var canSave: Bool {
        newPIN.count == 4 && newPIN == confirmPIN &&
        (!user.hasPIN || currentPIN.count == 4)
    }

    var body: some View {
        NavigationStack {
            List {
                if user.hasPIN {
                    Section("Current PIN") {
                        SecureField("4-digit PIN", text: $currentPIN)
                            .keyboardType(.numberPad)
                            .onChange(of: currentPIN) { _, v in currentPIN = String(v.filter(\.isNumber).prefix(4)) }
                    }
                }
                Section("New PIN") {
                    SecureField("4-digit PIN", text: $newPIN)
                        .keyboardType(.numberPad)
                        .onChange(of: newPIN) { _, v in newPIN = String(v.filter(\.isNumber).prefix(4)) }
                    SecureField("Confirm PIN", text: $confirmPIN)
                        .keyboardType(.numberPad)
                        .onChange(of: confirmPIN) { _, v in confirmPIN = String(v.filter(\.isNumber).prefix(4)) }
                }
                if let msg = errorMessage {
                    Section {
                        Label(msg, systemImage: "exclamationmark.triangle.fill")
                            .foregroundStyle(.red).font(.caption)
                    }
                }
            }
            .navigationTitle(user.hasPIN ? "Change PIN" : "Set PIN")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading)  { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        guard newPIN == confirmPIN else { errorMessage = "PINs don't match."; return }
                        user.hasPIN = true
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(!canSave)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        KidSecurityView()
            .environment(User.sample)
    }
}
