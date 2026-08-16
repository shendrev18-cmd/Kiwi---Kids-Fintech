import SwiftUI

struct SuggestChoreView: View {
    @Environment(User.self) private var user
    @Environment(\.dismiss) private var dismiss

    @State private var title    = ""
    @State private var amount   = 5.0
    @State private var category = ChoreCategory.household

    private var canSend: Bool { !title.trimmingCharacters(in: .whitespaces).isEmpty }

    var body: some View {
        NavigationStack {
            List {
                Section("What do you want to do?") {
                    TextField("e.g. Organise the garage", text: $title)
                        .autocorrectionDisabled()
                }

                Section("Amount you'd like to earn") {
                    Stepper(value: $amount, in: 0.50...50, step: 0.50) {
                        Text(amount, format: .currency(code: "USD"))
                            .font(.headline)
                    }
                }

                Section("Category") {
                    Picker("Category", selection: $category) {
                        ForEach(ChoreCategory.allCases, id: \.rawValue) { cat in
                            Label(cat.rawValue, systemImage: cat.icon).tag(cat)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
            .navigationTitle("Suggest a Chore")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Send to Parent") {
                        user.chores.append(Chore(
                            id: UUID(),
                            title: title.trimmingCharacters(in: .whitespaces),
                            amount: amount,
                            category: category,
                            status: .waitingOnParent,
                            requiresPhoto: false,
                            suggestedByKid: true,
                            hasPhotoProof: false,
                            dateCompleted: nil
                        ))
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(!canSend)
                }
            }
        }
    }
}

#Preview {
    SuggestChoreView()
        .environment(User.sample)
}
