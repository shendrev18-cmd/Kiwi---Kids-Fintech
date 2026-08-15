import Foundation

// MARK: - HomeViewModel

/// Drives the Home screen. Uses Swift's @Observable macro for fine-grained
/// view invalidation — only the properties actually read by a view trigger redraws.
///
/// Marked @MainActor for Swift 6 strict concurrency: all property accesses
/// happen on the main actor, which is correct for UI-driving state.
@MainActor
@Observable
final class HomeViewModel {

    // MARK: State

    var user: User                                 = .mock
    var transactions: [Transaction]                = Transaction.mockTransactions
    var savingsGoals: [SavingsGoal]                = SavingsGoal.mockGoals
    var earningOpportunities: [EarningOpportunity] = EarningOpportunity.mockOpportunities

    // MARK: Derived

    /// Most recent 5 transactions, newest first.
    var recentTransactions: [Transaction] {
        Array(transactions.sorted { $0.date > $1.date }.prefix(5))
    }

    /// Goals that haven't been fully funded yet.
    var activeGoals: [SavingsGoal] {
        savingsGoals.filter { !$0.isCompleted }
    }

    /// Up to 3 incomplete chores to feature on the home screen.
    var featuredOpportunities: [EarningOpportunity] {
        Array(earningOpportunities.filter { !$0.isCompleted }.prefix(3))
    }

    /// Total money earned in the current calendar week.
    var totalEarnedThisWeek: Decimal {
        transactions
            .filter { $0.isIncoming && Calendar.current.isDateInThisWeek($0.date) }
            .reduce(Decimal.zero) { $0 + $1.amount }
    }
}

// MARK: - Calendar helper

private extension Calendar {
    func isDateInThisWeek(_ date: Date) -> Bool {
        isDate(date, equalTo: .now, toGranularity: .weekOfYear)
    }
}
