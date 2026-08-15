import SwiftUI

struct EditParentProfileView: View {
    @Environment(ParentUser.self) private var parent
    @Environment(\.dismiss) private var dismiss

    private let gradientOptions: [(String, [Color])] = [
        ("Blue & Teal",     [.blue,   .teal]),
        ("Purple & Indigo", [.purple, .indigo]),
        ("Green & Mint",    [.green,  .mint]),
        ("Orange & Red",    [.orange, .red]),
        ("Pink & Purple",   [.pink,   .purple]),
    ]

    var body: some View {
        @Bindable var parent = parent

        NavigationStack {
            List {
                // Avatar preview
                Section {
                    HStack {
                        Spacer()
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: parent.avatarGradientColors,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 80, height: 80)
                            .overlay {
                                Text(parent.avatarInitials)
                                    .font(.system(size: 28, weight: .bold, design: .rounded))
                                    .foregroundStyle(.white)
                            }
                            .shadow(
                                color: (parent.avatarGradientColors.first ?? .blue).opacity(0.4),
                                radius: 10, y: 4
                            )
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    .listRowBackground(Color.clear)
                }

                // Name
                Section("Display Name") {
                    TextField("Full name", text: $parent.name)
                        .autocorrectionDisabled()
                }

                // Contact
                Section("Contact") {
                    HStack {
                        Label("Phone", systemImage: "phone")
                        Spacer()
                        TextField("Phone", text: $parent.phone)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.phonePad)
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Label("Email", systemImage: "envelope")
                        Spacer()
                        TextField("Email", text: $parent.email)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .foregroundStyle(.secondary)
                    }
                }

                // Avatar color
                Section("Avatar Color") {
                    ForEach(gradientOptions, id: \.0) { option in
                        Button {
                            parent.avatarGradientColors = option.1
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
                                if parent.avatarGradientColors == option.1 {
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
                    Button("Cancel") { dismiss() }
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

    private func applyInitials() {
        let initials = parent.name
            .split(separator: " ")
            .prefix(2)
            .compactMap(\.first)
            .map(String.init)
            .joined()
            .uppercased()
        parent.avatarInitials = initials.isEmpty ? "?" : initials
    }
}

#Preview {
    EditParentProfileView()
        .environment(ParentUser.sample)
}
