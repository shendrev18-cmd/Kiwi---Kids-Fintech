import Foundation

// MARK: - ChoreFrequency

enum ChoreFrequency: Sendable {
    case daily, weekly, oneTime

    var displayText: String {
        switch self {
        case .daily:   "Daily"
        case .weekly:  "Weekly"
        case .oneTime: "One-time"
        }
    }
}

// MARK: - EarningOpportunity

struct EarningOpportunity: Identifiable, Sendable {
    let id: UUID
    var title: String
    var choreDescription: String
    var reward: Decimal
    var iconSymbol: String
    var colorTheme: GoalColorTheme
    var frequency: ChoreFrequency
    var isCompleted: Bool
}

// MARK: - Mock data

extension EarningOpportunity {
    static let mockOpportunities: [EarningOpportunity] = [
        EarningOpportunity(
            id: UUID(), title: "Clean Your Room",
            choreDescription: "Tidy up and vacuum the floor",
            reward: 2.00, iconSymbol: "house.fill",
            colorTheme: .orange, frequency: .daily, isCompleted: false
        ),
        EarningOpportunity(
            id: UUID(), title: "Walk the Dog",
            choreDescription: "30-minute walk outside",
            reward: 3.00, iconSymbol: "dog.fill",
            colorTheme: .blue, frequency: .daily, isCompleted: false
        ),
        EarningOpportunity(
            id: UUID(), title: "Read for 30 min",
            choreDescription: "Any book you like!",
            reward: 1.50, iconSymbol: "book.fill",
            colorTheme: .purple, frequency: .daily, isCompleted: false
        ),
    ]
}
