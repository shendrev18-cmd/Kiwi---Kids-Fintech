import SwiftUI

struct EditProfileView: View {
    @Environment(User.self) private var user
    @Environment(\.dismiss) private var dismiss

    private let gradientOptions: [(String, [Color])] = [
        ("Pink & Purple",  [.pink, .purple]),
        ("Blue & Teal",    [.blue, .teal]),
        ("Green & Mint",   [.green, .mint]),
        ("Orange & Yellow",[.orange, .yellow]),
        ("Red & Pink",     [.red, .pink]),
    ]

    var body: some View {
        @Bindable var user = user

        NavigationStack {
            List {
                // MARK: Name
                Section("Display Name") {
                    TextField("Name", text: $user.name)
                        .autocorrectionDisabled()
                }

                // MARK: Avatar color
                Section("Avatar Color") {
                    ForEach(gradientOptions, id: \.0) { option in
                        Button {
                            user.avatarGradientColors = option.1
                        } label: {
                            HStack(spacing: 14) {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: option.1,
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 32, height: 32)
                                Text(option.0)
                                    .foregroundStyle(.primary)
                                Spacer()
                                if user.avatarGradientColors == option.1 {
                                    Image(systemName: "checkmark")
                                        .font(.body.weight(.semibold))
                                        .foregroundStyle(.tint)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        applyInitials()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }

    // MARK: - Helpers

    private func applyInitials() {
        let initials = user.name
            .split(separator: " ")
            .prefix(2)
            .compactMap(\.first)
            .map(String.init)
            .joined()
            .uppercased()
        user.avatarInitials = initials.isEmpty ? "?" : initials
    }
}

#Preview {
    EditProfileView()
        .environment(User.sample)
}
