import SwiftUI

// MARK: - TransactionType

enum TransactionType: Sendable {
    case spend, earn, transfer, goalContribution
}

// MARK: - TransactionCategory

enum TransactionCategory: Sendable {
    case food, entertainment, shopping, savings, earning, transport, gift

    /// SF Symbol name for the category icon.
    var symbol: String {
        switch self {
        case .food:          "fork.knife"
        case .entertainment: "gamecontroller.fill"
        case .shopping:      "bag.fill"
        case .savings:       "leaf.fill"
        case .earning:       "star.fill"
        case .transport:     "tram.fill"
        case .gift:          "gift.fill"
        }
    }

    /// Tint colour for the category icon badge.
    var color: Color {
        switch self {
        case .food:          .orange
        case .entertainment: .purple
        case .shopping:      .blue
        case .savings:       .kiweeGreen
        case .earning:       Color(red: 1.00, green: 0.75, blue: 0.00)
        case .transport:     .cyan
        case .gift:          .pink
        }
    }
}

// MARK: - Transaction

struct Transaction: Identifiable, Sendable {
    let id: UUID
    var merchant: String
    var amount: Decimal
    var type: TransactionType
    var category: TransactionCategory
    var date: Date

    var isIncoming: Bool { type == .earn }
}

// MARK: - Mock data

extension Transaction {
    static let mockTransactions: [Transaction] = [
        Transaction(
            id: UUID(), merchant: "Allowance",
            amount: 5.00, type: .earn, category: .earning,
            date: Calendar.current.date(byAdding: .hour, value: -2, to: .now)!
        ),
        Transaction(
            id: UUID(), merchant: "Grocery Store",
            amount: 4.50, type: .spend, category: .food,
            date: Calendar.current.date(byAdding: .hour, value: -5, to: .now)!
        ),
        Transaction(
            id: UUID(), merchant: "Game Store",
            amount: 12.99, type: .spend, category: .entertainment,
            date: Calendar.current.date(byAdding: .day, value: -1, to: .now)!
        ),
        Transaction(
            id: UUID(), merchant: "Bookshop",
            amount: 6.75, type: .spend, category: .shopping,
            date: Calendar.current.date(byAdding: .day, value: -1, to: .now)!
        ),
        Transaction(
            id: UUID(), merchant: "Savings Goal",
            amount: 10.00, type: .goalContribution, category: .savings,
            date: Calendar.current.date(byAdding: .day, value: -2, to: .now)!
        ),
    ]
}
