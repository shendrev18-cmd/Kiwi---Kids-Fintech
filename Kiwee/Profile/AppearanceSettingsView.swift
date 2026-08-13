import SwiftUI

struct AppearanceSettingsView: View {
    @Environment(User.self) private var user

    var body: some View {
        @Bindable var user = user

        List {
            Section {
                ForEach(AppearanceMode.allCases, id: \.rawValue) { mode in
                    Button {
                        user.appearanceMode = mode
                    } label: {
                        HStack {
                            Label(mode.label, systemImage: mode.icon)
                                .foregroundStyle(.primary)
                            Spacer()
                            if user.appearanceMode == mode {
                                Image(systemName: "checkmark")
                                    .font(.body.weight(.semibold))
                                    .foregroundStyle(.tint)
                            }
                        }
                    }
                }
            } footer: {
                Text("Changes how Kiwee looks on your screen.")
            }
        }
        .navigationTitle("Appearance")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        AppearanceSettingsView()
            .environment(User.sample)
    }
}
