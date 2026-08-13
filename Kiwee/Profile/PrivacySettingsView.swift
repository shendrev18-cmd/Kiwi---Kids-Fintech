import SwiftUI

struct PrivacySettingsView: View {
    var body: some View {
        List {
            Section {
                Label("No data leaves your device", systemImage: "iphone.and.arrow.forward")
                Label("Spending stays private", systemImage: "eye.slash")
                Label("No ads or tracking", systemImage: "hand.raised.slash")
            } header: {
                Text("How We Protect You")
            } footer: {
                Text("Kiwee stores all your information securely on this device. We never sell or share your personal data.")
            }

            Section("Legal") {
                NavigationLink {
                    PlaceholderDetailView(title: "Privacy Policy")
                } label: {
                    Label("Privacy Policy", systemImage: "doc.text")
                }
                NavigationLink {
                    PlaceholderDetailView(title: "Terms of Service")
                } label: {
                    Label("Terms of Service", systemImage: "doc.plaintext")
                }
            }
        }
        .navigationTitle("Privacy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Placeholder Detail

private struct PlaceholderDetailView: View {
    let title: String

    var body: some View {
        ContentUnavailableView(
            title,
            systemImage: "doc.text",
            description: Text("This document will be available in a future update.")
        )
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PrivacySettingsView()
    }
}
