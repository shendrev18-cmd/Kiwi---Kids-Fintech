import SwiftUI

/// Read-only view of linked parents/guardians — no editing on the kid side.
struct KidFamilyView: View {
    @Environment(User.self) private var user

    var body: some View {
        List {
            Section {
                if user.linkedParentNames.isEmpty {
                    ContentUnavailableView(
                        "No parent linked",
                        systemImage: "person.2",
                        description: Text("Ask your parent to invite you from their profile.")
                    )
                } else {
                    ForEach(user.linkedParentNames, id: \.self) { parentName in
                        HStack(spacing: 14) {
                            Circle()
                                .fill(LinearGradient(colors: [.blue, .teal],
                                                     startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 40, height: 40)
                                .overlay {
                                    Text(initials(from: parentName))
                                        .font(.system(size: 14, weight: .bold, design: .rounded))
                                        .foregroundStyle(.white)
                                }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(parentName)
                                    .font(.subheadline.weight(.medium))
                                Text("Parent · Can approve chores")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Image(systemName: "checkmark.seal.fill")
                                .foregroundStyle(.green)
                        }
                        .padding(.vertical, 4)
                    }
                }
            } header: {
                Text("Your Parents")
            } footer: {
                Text("Contact your parent to make changes to your family setup.")
            }
        }
        .navigationTitle("Family")
        .navigationBarTitleDisplayMode(.inline)
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

#Preview {
    NavigationStack {
        KidFamilyView()
            .environment(User.sample)
    }
}
