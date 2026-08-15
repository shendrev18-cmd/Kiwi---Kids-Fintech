import SwiftUI

struct ParentAppearanceView: View {
    @Environment(ParentUser.self) private var parent

    var body: some View {
        @Bindable var parent = parent

        List {
            Section {
                ForEach(AppearanceMode.allCases, id: \.rawValue) { mode in
                    Button {
                        parent.appearanceMode = mode
                    } label: {
                        HStack {
                            Label(mode.label, systemImage: mode.icon)
                                .foregroundStyle(.primary)
                            Spacer()
                            if parent.appearanceMode == mode {
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
        ParentAppearanceView()
            .environment(ParentUser.sample)
    }
}
