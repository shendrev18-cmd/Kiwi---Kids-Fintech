import Foundation

// MARK: - GoalContribution

struct GoalContribution: Identifiable, Sendable {
    let id: UUID
    let date: Date
    let amount: Double   // positive = moved in, negative = moved out
    let note: String
}

// MARK: - SavingsGoal

struct SavingsGoal: Identifiable, Sendable {
    let id: UUID
    var name: String
    var emoji: String
    var currentAmount: Double
    let targetAmount: Double
    let createdDate: Date
    var isCompleted: Bool
    var history: [GoalContribution]

    var progress: Double {
        guard targetAmount > 0 else { return 0 }
        return min(1.0, currentAmount / targetAmount)
    }
}
