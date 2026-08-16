import SwiftUI

// MARK: - ChoreStatus

enum ChoreStatus: String, CaseIterable, Sendable {
    case toDo            = "To Do"
    case waitingOnParent = "Waiting"
    case approved        = "Approved"
    case needsRedo       = "Needs Redo"

    var color: Color {
        switch self {
        case .toDo:            .blue
        case .waitingOnParent: .orange
        case .approved:        .green
        case .needsRedo:       .red
        }
    }

    var icon: String {
        switch self {
        case .toDo:            "circle"
        case .waitingOnParent: "clock.fill"
        case .approved:        "checkmark.circle.fill"
        case .needsRedo:       "arrow.clockwise.circle.fill"
        }
    }
}

// MARK: - ChoreCategory

enum ChoreCategory: String, CaseIterable, Sendable {
    case household = "Household"
    case outdoor   = "Outdoor"
    case pet       = "Pet Care"
    case academic  = "Academic"
    case custom    = "Custom"

    var icon: String {
        switch self {
        case .household: "house"
        case .outdoor:   "leaf"
        case .pet:       "pawprint"
        case .academic:  "book"
        case .custom:    "star"
        }
    }
}

// MARK: - Chore

struct Chore: Identifiable, Sendable {
    let id: UUID
    var title: String
    var amount: Double
    var category: ChoreCategory
    var status: ChoreStatus
    var requiresPhoto: Bool
    var suggestedByKid: Bool
    var hasPhotoProof: Bool
    var dateCompleted: Date?
}
