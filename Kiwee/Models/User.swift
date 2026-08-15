import SwiftUI

// MARK: - AccountType

enum AccountType: String, CaseIterable, Sendable {
    case kid
    case parent

    var label: String {
        switch self {
        case .kid:    "Kiwee Kid"
        case .parent: "Parent"
        }
    }

    var emoji: String {
        switch self {
        case .kid:    "🧒"
        case .parent: "👨‍👩‍👧"
        }
    }
}

// MARK: - AppearanceMode

enum AppearanceMode: String, CaseIterable, Sendable {
    case system
    case light
    case dark

    var label: String {
        switch self {
        case .system: "System"
        case .light:  "Light"
        case .dark:   "Dark"
        }
    }

    var icon: String {
        switch self {
        case .system: "circle.lefthalf.filled"
        case .light:  "sun.max"
        case .dark:   "moon"
        }
    }
}

// MARK: - KiweeLevel

enum KiweeLevel: CaseIterable, Sendable {
    case seedling
    case sprout
    case sapling
    case tree
    case superStar

    var label: String {
        switch self {
        case .seedling:  "Seedling"
        case .sprout:    "Sprout"
        case .sapling:   "Sapling"
        case .tree:      "Tree"
        case .superStar: "Super Star"
        }
    }

    var emoji: String {
        switch self {
        case .seedling:  "🌱"
        case .sprout:    "🌿"
        case .sapling:   "🌳"
        case .tree:      "🌲"
        case .superStar: "⭐️"
        }
    }

    var color: Color {
        switch self {
        case .seedling:  .green
        case .sprout:    .teal
        case .sapling:   .blue
        case .tree:      .purple
        case .superStar: .orange
        }
    }

    var minXP: Int {
        switch self {
        case .seedling:  0
        case .sprout:    100
        case .sapling:   300
        case .tree:      700
        case .superStar: 1500
        }
    }

    var nextLevelXP: Int? {
        switch self {
        case .seedling:  100
        case .sprout:    300
        case .sapling:   700
        case .tree:      1500
        case .superStar: nil
        }
    }

    static func level(for xp: Int) -> KiweeLevel {
        KiweeLevel.allCases.reversed().first { xp >= $0.minXP } ?? .seedling
    }
}

// MARK: - User

@Observable
@MainActor
final class User {
    var name: String
    var avatarInitials: String
    var avatarGradientColors: [Color]
    var accountType: AccountType
    var memberSince: Date
    var xp: Int
    var balance: Decimal
    var totalEarned: Double
    var totalSaved: Double
    var choresCompleted: Int
    var notificationsEnabled: Bool
    var choreRemindersEnabled: Bool
    var savingsAlertsEnabled: Bool
    var appearanceMode: AppearanceMode

    init(
        name: String,
        avatarInitials: String,
        avatarGradientColors: [Color],
        accountType: AccountType,
        memberSince: Date,
        xp: Int,
        balance: Decimal = 0,
        totalEarned: Double,
        totalSaved: Double,
        choresCompleted: Int,
        notificationsEnabled: Bool,
        choreRemindersEnabled: Bool,
        savingsAlertsEnabled: Bool,
        appearanceMode: AppearanceMode
    ) {
        self.name = name
        self.avatarInitials = avatarInitials
        self.avatarGradientColors = avatarGradientColors
        self.accountType = accountType
        self.memberSince = memberSince
        self.xp = xp
        self.balance = balance
        self.totalEarned = totalEarned
        self.totalSaved = totalSaved
        self.choresCompleted = choresCompleted
        self.notificationsEnabled = notificationsEnabled
        self.choreRemindersEnabled = choreRemindersEnabled
        self.savingsAlertsEnabled = savingsAlertsEnabled
        self.appearanceMode = appearanceMode
    }

    // MARK: Derived

    var level: KiweeLevel { KiweeLevel.level(for: xp) }

    /// First word of the name, used by the home screen greeting.
    var firstName: String {
        let parts = name.split(separator: " ")
        return parts.first.map(String.init) ?? name
    }

    // MARK: Mock / sample data

    @MainActor
    static let sample = User(
        name: "Kiwee Kid",
        avatarInitials: "KK",
        avatarGradientColors: [.pink, .purple],
        accountType: .kid,
        memberSince: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 1))!,
        xp: 340,
        balance: 1340.25,
        totalEarned: 142.50,
        totalSaved: 87.50,
        choresCompleted: 24,
        notificationsEnabled: true,
        choreRemindersEnabled: true,
        savingsAlertsEnabled: true,
        appearanceMode: .system
    )

    /// Alias used by `HomeViewModel`.
    @MainActor static let mock = sample
}
