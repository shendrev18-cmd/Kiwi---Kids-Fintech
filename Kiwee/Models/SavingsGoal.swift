import SwiftUI

// MARK: - GoalColorTheme

/// Shared colour theme used by savings goals and earning opportunities.
enum GoalColorTheme: String, CaseIterable, Sendable {
    case purple, blue, green, orange, pink, teal

    var color: Color {
        switch self {
        case .purple: .purple
        case .blue:   .blue
        case .green:  .kiweeGreen
        case .orange: .orange
        case .pink:   .pink
        case .teal:   .teal
        }
    }

    var progressGradient: LinearGradient {
        LinearGradient(
            colors: [color, color.opacity(0.60)],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

// MARK: - SavingsGoal

struct SavingsGoal: Identifiable, Sendable {
    let id: UUID
    var name: String
    var iconSymbol: String
    var targetAmount: Decimal
    var currentAmount: Decimal
    var colorTheme: GoalColorTheme
    var targetDate: Date?

    /// Completion ratio in [0, 1]. Bridges through NSDecimalNumber to avoid
    /// missing `operator /` on Decimal in Swift.
    var progress: Double {
        guard targetAmount > 0 else { return 0 }
        let current = (currentAmount as NSDecimalNumber).doubleValue
        let target  = (targetAmount  as NSDecimalNumber).doubleValue
        return min(max(current / target, 0), 1.0)
    }

    var isCompleted: Bool    { currentAmount >= targetAmount }
    var remainingAmount: Decimal { max(targetAmount - currentAmount, 0) }
    var progressPercent: Int { Int(progress * 100) }
}

// MARK: - Mock data

extension SavingsGoal {
    static let mockGoals: [SavingsGoal] = [
        SavingsGoal(
            id: UUID(), name: "New iPad",
            iconSymbol: "ipad.gen2",
            targetAmount: 329.00, currentAmount: 145.00,
            colorTheme: .blue
        ),
        SavingsGoal(
            id: UUID(), name: "Birthday Party",
            iconSymbol: "party.popper.fill",
            targetAmount: 80.00, currentAmount: 32.00,
            colorTheme: .pink
        ),
        SavingsGoal(
            id: UUID(), name: "New Bike",
            iconSymbol: "bicycle",
            targetAmount: 200.00, currentAmount: 89.50,
            colorTheme: .green
        ),
    ]
}
