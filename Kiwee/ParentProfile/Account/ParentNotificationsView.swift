import SwiftUI

struct ParentNotificationsView: View {
    @Environment(ParentUser.self) private var parent

    var body: some View {
        @Bindable var parent = parent

        List {
            Section {
                Toggle(isOn: $parent.notifyApprovalRequests) {
                    Label("Approval Requests", systemImage: "hand.tap")
                }
                Toggle(isOn: $parent.notifyChoreCompletions) {
                    Label("Chore Completions", systemImage: "checkmark.circle")
                }
                Toggle(isOn: $parent.notifyAllowanceSent) {
                    Label("Allowance Sent", systemImage: "gift")
                }
                Toggle(isOn: $parent.notifyLowBalance) {
                    Label("Low Balance", systemImage: "exclamationmark.circle")
                }
            } header: {
                Text("Activity")
            } footer: {
                Text("Get notified for important account activity.")
            }

            Section {
                Toggle(isOn: $parent.notifyWeeklyDigest) {
                    Label("Weekly Digest", systemImage: "calendar")
                }
            } header: {
                Text("Summary")
            } footer: {
                Text("A weekly summary of chores completed, money earned, and savings progress — delivered every Sunday.")
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ParentNotificationsView()
            .environment(ParentUser.sample)
    }
}
