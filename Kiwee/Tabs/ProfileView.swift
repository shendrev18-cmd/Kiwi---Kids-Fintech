import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 16) {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.pink, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 60, height: 60)
                            .overlay {
                                Text("K")
                                    .font(.lexend(.title, weight: .bold))
                                    .foregroundStyle(.white)
                            }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Kiwee Kid")
                                .font(.lexend(.title3, weight: .bold))
                            Text("Member since 2025")
                                .font(.figtree(.caption))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }

                Section {
                    Label("Notifications", systemImage: "bell")
                        .font(.figtree(.body))
                    Label("Privacy", systemImage: "lock")
                        .font(.figtree(.body))
                    Label("Appearance", systemImage: "paintbrush")
                        .font(.figtree(.body))
                    Label("Family", systemImage: "person.2")
                        .font(.figtree(.body))
                } header: {
                    Text("Account")
                        .font(.figtree(.caption, weight: .semibold))
                }

                Section {
                    Label("Help Center", systemImage: "questionmark.circle")
                        .font(.figtree(.body))
                    Label("Send Feedback", systemImage: "envelope")
                        .font(.figtree(.body))
                    Label("About Kiwee", systemImage: "info.circle")
                        .font(.figtree(.body))
                } header: {
                    Text("Support")
                        .font(.figtree(.caption, weight: .semibold))
                }
            }
            .navigationTitle("Profile")
        }
    }
}
