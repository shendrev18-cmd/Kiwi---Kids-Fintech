import SwiftUI

// MARK: - TransactionCategory

enum TransactionCategory: String, Sendable {
    case earned
    case spent
    case saved
    case pending

    var icon: String {
        switch self {
        case .earned:  "arrow.down.circle.fill"
        case .spent:   "arrow.up.circle.fill"
        case .saved:   "target"
        case .pending: "clock.fill"
        }
    }

    var color: Color {
        switch self {
        case .earned:  .green
        case .spent:   .red
        case .saved:   .purple
        case .pending: .orange
        }
    }

    var label: String { rawValue.capitalized }
}

// MARK: - TransactionStatus

enum TransactionStatus: Sendable {
    case completed
    case pending
}

// MARK: - ActivityTransaction

struct ActivityTransaction: Identifiable, Sendable {
    let id: UUID
    let date: Date
    let title: String
    /// Reason line shown under the title: "Chore approved · Dishes" / "Moved to New Bike"
    let contextLine: String
    let amount: Double            // positive = credit, negative = debit
    let category: TransactionCategory
    var status: TransactionStatus
    var hasPhotoProof: Bool
    var note: String
    var balanceBefore: Double
    var balanceAfter: Double
}
