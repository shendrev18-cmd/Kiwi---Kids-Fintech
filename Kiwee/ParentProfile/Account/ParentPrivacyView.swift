import SwiftUI

struct ParentPrivacyView: View {
    var body: some View {
        List {
            Section {
                Label("All data is stored on-device", systemImage: "iphone.and.arrow.forward")
                Label("No data sold or shared", systemImage: "hand.raised.slash")
                Label("Child data never leaves your family", systemImage: "lock.shield")
            } header: {
                Text("Our Commitments")
            } footer: {
                Text("Kiwee does not use analytics trackers or sell personal data to third parties.")
            }

            Section {
                NavigationLink {
                    ChildDataControlsView()
                } label: {
                    Label("Child Data Controls", systemImage: "figure.and.child.holdinghands")
                }
                NavigationLink {
                    DataExportView()
                } label: {
                    Label("Export My Data", systemImage: "square.and.arrow.up")
                }
            } header: {
                Text("Your Controls")
            }

            Section("Legal") {
                NavigationLink {
                    PrivacyPolicyView()
                } label: {
                    Label("Privacy Policy", systemImage: "doc.text")
                }
                NavigationLink {
                    TermsOfServiceView()
                } label: {
                    Label("Terms of Service", systemImage: "doc.plaintext")
                }
            }
        }
        .navigationTitle("Privacy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - ChildDataControlsView

private struct ChildDataControlsView: View {
    var body: some View {
        List {
            Section {
                Label("Activity logs kept for 90 days", systemImage: "clock.arrow.circlepath")
                Label("Chore photos never stored", systemImage: "photo.slash")
                Label("No cross-device child profiling", systemImage: "eye.slash")
            } header: {
                Text("How Child Data is Handled")
            } footer: {
                Text("Removing a child from your account permanently deletes all their associated data.")
            }
        }
        .navigationTitle("Child Data")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - DataExportView

private struct DataExportView: View {
    @Environment(ParentUser.self) private var parent

    private var exportText: String {
        "Kiwee Data Export\n\nName: \(parent.name)\nEmail: \(parent.email)\nPhone: \(parent.phone)\nChildren: \(parent.children.map(\.name).joined(separator: ", "))\n"
    }

    var body: some View {
        List {
            Section {
                ShareLink(
                    item: exportText,
                    subject: Text("My Kiwee Data"),
                    message: Text("Exported from Kiwee.")
                ) {
                    Label("Export Account Data", systemImage: "square.and.arrow.up")
                }
            } footer: {
                Text("Exports your account information and transaction history as a plain text file.")
            }
        }
        .navigationTitle("Export Data")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ParentPrivacyView()
            .environment(ParentUser.sample)
    }
}
