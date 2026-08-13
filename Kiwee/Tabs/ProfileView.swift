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

                Section("Account") {
                    Label("Notifications", systemImage: "bell")
                    Label("Privacy", systemImage: "lock")
                    Label("Appearance", systemImage: "paintbrush")
                    Label("Family", systemImage: "person.2")
                }

                Section("Support") {
                    Label("Help Center", systemImage: "questionmark.circle")
                    Label("Send Feedback", systemImage: "envelope")
                    Label("About Kiwee", systemImage: "info.circle")
                }
            }
            .navigationTitle("Profile")
        }
    }
}
