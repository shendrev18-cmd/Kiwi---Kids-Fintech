import SwiftUI

struct SendFeedbackView: View {
    private enum Category: String, CaseIterable {
        case general     = "General Feedback"
        case bug         = "Bug Report"
        case feature     = "Feature Request"
        case chores      = "Chores"
        case savings     = "Savings Goals"

        var icon: String {
            switch self {
            case .general:  "text.bubble"
            case .bug:      "ladybug"
            case .feature:  "lightbulb"
            case .chores:   "list.bullet.clipboard"
            case .savings:  "target"
            }
        }
    }

    @State private var selectedCategory: Category = .general
    @State private var feedbackText: String = ""
    @State private var didSubmit = false

    private var canSubmit: Bool { !feedbackText.trimmingCharacters(in: .whitespaces).isEmpty }

    var body: some View {
        List {
            Section("Category") {
                Picker("Category", selection: $selectedCategory) {
                    ForEach(Category.allCases, id: \.rawValue) { category in
                        Label(category.rawValue, systemImage: category.icon)
                            .tag(category)
                    }
                }
                .pickerStyle(.menu)
            }

            Section("Your Feedback") {
                TextField("Tell us what you think...", text: $feedbackText, axis: .vertical)
                    .lineLimit(4...8)
                    .autocorrectionDisabled(false)
            }

            Section {
                Button {
                    didSubmit = true
                    feedbackText = ""
                    selectedCategory = .general
                } label: {
                    Label("Send Feedback", systemImage: "paperplane.fill")
                        .frame(maxWidth: .infinity)
                }
                .disabled(!canSubmit)
            }
        }
        .navigationTitle("Send Feedback")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Thanks! 🎉", isPresented: $didSubmit) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("We read every message. Your feedback helps make Kiwee better for everyone!")
        }
    }
}

#Preview {
    NavigationStack {
        SendFeedbackView()
    }
}
