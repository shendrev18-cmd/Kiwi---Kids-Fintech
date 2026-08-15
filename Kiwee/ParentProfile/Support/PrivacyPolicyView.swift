import SwiftUI

struct PrivacyPolicyView: View {
    private let sections: [(title: String, body: String)] = [
        (
            "Information We Collect",
            "We collect account information you provide (name, email, phone), transaction data generated within the app, and device identifiers for security. We do not collect location data or contact lists."
        ),
        (
            "How We Use Your Information",
            "Your information is used solely to operate the Kiwee service — processing transactions, sending notifications you opt into, and providing customer support. We never use your data for advertising."
        ),
        (
            "Children's Privacy",
            "Child accounts are managed by a verified parent or guardian. We collect only the minimum data necessary to operate children's features (name, balance, chore activity). Child data is never used for profiling or shared with third parties."
        ),
        (
            "Data Storage & Security",
            "All personal data is stored on-device where possible. Synced data is encrypted in transit and at rest. We retain transaction data for 90 days; account data is retained until you request deletion."
        ),
        (
            "Sharing",
            "We do not sell your data. We do not share your data with advertisers. We may share data with service providers strictly necessary to operate Kiwee (e.g., payment processors), under data processing agreements."
        ),
        (
            "Your Rights",
            "You may request a copy of your data, correct inaccuracies, or request deletion at any time from Settings → Privacy → Export My Data, or by contacting privacy@kiwee.app."
        ),
        (
            "Contact",
            "Privacy questions or requests: privacy@kiwee.app"
        ),
    ]

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Effective: January 1, 2025")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("Last updated: January 1, 2025")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }

            ForEach(sections, id: \.title) { section in
                Section(section.title) {
                    Text(section.body)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.vertical, 2)
                }
            }
        }
        .navigationTitle("Privacy Policy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PrivacyPolicyView()
    }
}
