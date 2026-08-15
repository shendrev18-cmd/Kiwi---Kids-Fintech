import SwiftUI

struct SecurityView: View {
    @Environment(ParentUser.self) private var parent

    @State private var showChangePIN = false

    var body: some View {
        @Bindable var parent = parent

        List {
            // Authentication
            Section {
                Button {
                    showChangePIN = true
                } label: {
                    HStack {
                        Label(parent.hasPIN ? "Change PIN" : "Set PIN", systemImage: "lock.rotation")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.tertiary)
                    }
                }
                .foregroundStyle(.primary)

                Toggle(isOn: $parent.biometricEnabled) {
                    Label("Face ID / Touch ID", systemImage: "faceid")
                }
            } header: {
                Text("Authentication")
            } footer: {
                Text("Use biometrics to sign in quickly and securely.")
            }

            // Payments
            Section {
                Toggle(isOn: $parent.requireAuthForPayments) {
                    Label("Require Auth for Payments", systemImage: "lock.shield")
                }
            } header: {
                Text("Payments")
            } footer: {
                Text("Re-authenticate before any money moves out of the family account.")
            }

            // Sessions
            Section {
                HStack {
                    Label("This iPhone", systemImage: "iphone")
                    Spacer()
                    Text("Active now")
                        .font(.caption)
                        .foregroundStyle(.green)
                }
            } header: {
                Text("Active Sessions")
            } footer: {
                Text("Signing out of a session requires the account password to sign back in.")
            }
        }
        .navigationTitle("Security")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showChangePIN) {
            ChangePINView()
        }
    }
}

// MARK: - ChangePINView

private struct ChangePINView: View {
    @Environment(ParentUser.self) private var parent
    @Environment(\.dismiss) private var dismiss

    @State private var currentPIN = ""
    @State private var newPIN     = ""
    @State private var confirmPIN = ""
    @State private var errorMessage: String? = nil

    private var canSave: Bool {
        newPIN.count == 4 && newPIN == confirmPIN &&
        (!parent.hasPIN || currentPIN.count == 4)
    }

    var body: some View {
        NavigationStack {
            List {
                if parent.hasPIN {
                    Section("Current PIN") {
                        SecureField("Current 4-digit PIN", text: $currentPIN)
                            .keyboardType(.numberPad)
                            .onChange(of: currentPIN) { _, new in
                                currentPIN = String(new.filter(\.isNumber).prefix(4))
                            }
                    }
                }
                Section("New PIN") {
                    SecureField("4-digit PIN", text: $newPIN)
                        .keyboardType(.numberPad)
                        .onChange(of: newPIN) { _, new in newPIN = String(new.filter(\.isNumber).prefix(4)) }
                    SecureField("Confirm PIN", text: $confirmPIN)
                        .keyboardType(.numberPad)
                        .onChange(of: confirmPIN) { _, new in confirmPIN = String(new.filter(\.isNumber).prefix(4)) }
                }
                if let msg = errorMessage {
                    Section {
                        Label(msg, systemImage: "exclamationmark.triangle.fill")
                            .foregroundStyle(.red)
                            .font(.caption)
                    }
                }
            }
            .navigationTitle(parent.hasPIN ? "Change PIN" : "Set PIN")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading)  { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        guard newPIN == confirmPIN else {
                            errorMessage = "PINs don't match."
                            return
                        }
                        parent.hasPIN = true
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(!canSave)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        SecurityView()
            .environment(ParentUser.sample)
    }
}
