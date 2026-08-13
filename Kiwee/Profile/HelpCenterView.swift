import SwiftUI

struct HelpCenterView: View {
    private struct FAQ {
        let question: String
        let icon: String
    }

    private let faqs: [FAQ] = [
        FAQ(question: "How do I earn Kiwee coins?",      icon: "dollarsign.circle"),
        FAQ(question: "How do I set a savings goal?",    icon: "target"),
        FAQ(question: "Can I get money from my parents?", icon: "person.2"),
        FAQ(question: "What are chores?",                icon: "list.bullet.clipboard"),
        FAQ(question: "How do I level up?",              icon: "star.circle"),
        FAQ(question: "How do I change my avatar?",      icon: "person.crop.circle"),
    ]

    var body: some View {
        List {
            Section("Frequently Asked Questions") {
                ForEach(faqs, id: \.question) { faq in
                    NavigationLink {
                        FAQDetailView(title: faq.question)
                    } label: {
                        Label(faq.question, systemImage: faq.icon)
                    }
                }
            }

            Section("Contact") {
                Label("support@kiwee.app", systemImage: "envelope")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Help Center")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - FAQ Detail

private struct FAQDetailView: View {
    let title: String

    var body: some View {
        ContentUnavailableView(
            title,
            systemImage: "questionmark.circle",
            description: Text("Full answer coming soon! In the meantime, ask a parent for help.")
        )
        .navigationTitle("FAQ")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        HelpCenterView()
    }
}
