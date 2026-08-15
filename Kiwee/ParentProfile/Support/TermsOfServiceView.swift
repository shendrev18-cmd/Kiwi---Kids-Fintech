import SwiftUI

struct TermsOfServiceView: View {
    private let sections: [(title: String, body: String)] = [
        (
            "Acceptance of Terms",
            "By creating a Kiwee account, you agree to these Terms of Service. Kiwee is intended for use by parents and their children under parental supervision. You must be 18 or older to create a parent account."
        ),
        (
            "Account Responsibilities",
            "You are responsible for maintaining the security of your account credentials and PIN. You agree to notify Kiwee immediately of any unauthorized access. You are responsible for all activity that occurs under your account."
        ),
        (
            "Financial Features",
            "Kiwee's payment and balance features are provided for family use only. Auto-reload and payment method linking are subject to your financial institution's terms. Kiwee does not guarantee funds availability and is not a licensed bank."
        ),
        (
            "Children's Accounts",
            "Child accounts must be created and supervised by a parent or legal guardian. You confirm you have the legal authority to create accounts for the children in your family group. Children's data is handled per our Privacy Policy."
        ),
        (
            "Prohibited Use",
            "You may not use Kiwee for commercial purposes, to circumvent financial regulations, or in any way that violates applicable law. Misuse may result in account suspension."
        ),
        (
            "Modifications",
            "Kiwee may update these terms at any time. Continued use after changes constitutes acceptance. We will notify you of material changes via the email on your account."
        ),
        (
            "Contact",
            "Questions about these terms? Email us at legal@kiwee.app."
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
        .navigationTitle("Terms of Service")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        TermsOfServiceView()
    }
}
