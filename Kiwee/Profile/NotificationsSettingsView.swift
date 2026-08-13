import SwiftUI

struct NotificationsSettingsView: View {
    @Environment(User.self) private var user

    var body: some View {
        @Bindable var user = user

        List {
            Section {
                Toggle(isOn: $user.notificationsEnabled) {
                    Label("All Notifications", systemImage: "bell.badge")
                }
            } header: {
                Text("Notifications")
            } footer: {
                Text("Turn off to silence all Kiwee alerts.")
            }

            Section {
                Toggle(isOn: $user.choreRemindersEnabled) {
                    Label("Chore Reminders", systemImage: "list.bullet.clipboard")
                }
                .disabled(!user.notificationsEnabled)

                Toggle(isOn: $user.savingsAlertsEnabled) {
                    Label("Savings Milestones", systemImage: "star")
                }
                .disabled(!user.notificationsEnabled)
            } header: {
                Text("Chores & Goals")
            } footer: {
                if !user.notificationsEnabled {
                    Text("Enable notifications above to manage these settings.")
                }
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        NotificationsSettingsView()
            .environment(User.sample)
    }
}
