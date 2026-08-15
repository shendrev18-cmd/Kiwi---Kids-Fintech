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
    var avatarEmoji: String
    var accentColorHex: String
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
        avatarEmoji: String = "🚀",
        accentColorHex: String = "#29C76A"
    ) {
        self.name = name
        self.avatarInitials = avatarInitials
        self.avatarGradientColors = avatarGradientColors
        self.avatarEmoji = avatarEmoji
        self.accentColorHex = accentColorHex
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
    }

    // MARK: Derived

    var level: KiweeLevel { KiweeLevel.level(for: xp) }

    /// First word of the name, used by the home screen greeting.
    var firstName: String {
        let parts = name.split(separator: " ")
        return parts.first.map(String.init) ?? name
    }

    /// The user's accent color reconstructed from hex.
    var accentColor: Color {
        Color(hex: accentColorHex) ?? .kiweeGreen
    }

    // MARK: Persistence

    private static let defaults = UserDefaults.standard
    private enum Key {
        static let name = "kiwee_user_name"
        static let avatarInitials = "kiwee_user_initials"
        static let avatarEmoji = "kiwee_user_emoji"
        static let accentColorHex = "kiwee_user_accent"
        static let accountType = "kiwee_user_accountType"
        static let gradientColor1 = "kiwee_user_grad1"
        static let gradientColor2 = "kiwee_user_grad2"
    }

    /// Save essential profile fields to UserDefaults.
    func save() {
        Self.defaults.set(name, forKey: Key.name)
        Self.defaults.set(avatarInitials, forKey: Key.avatarInitials)
        Self.defaults.set(avatarEmoji, forKey: Key.avatarEmoji)
        Self.defaults.set(accentColorHex, forKey: Key.accentColorHex)
        Self.defaults.set(accountType.rawValue, forKey: Key.accountType)
        if avatarGradientColors.count >= 2 {
            Self.defaults.set(avatarGradientColors[0].hexString, forKey: Key.gradientColor1)
            Self.defaults.set(avatarGradientColors[1].hexString, forKey: Key.gradientColor2)
        }
    }

    /// Load a saved user from UserDefaults, or return `sample` if nothing is saved.
    @MainActor
    static func loadOrSample() -> User {
        guard let name = defaults.string(forKey: Key.name), !name.isEmpty else {
            return sample
        }
        let grad1 = Color(hex: defaults.string(forKey: Key.gradientColor1) ?? "") ?? .blue
        let grad2 = Color(hex: defaults.string(forKey: Key.gradientColor2) ?? "") ?? .cyan
        return User(
            name: name,
            avatarInitials: defaults.string(forKey: Key.avatarInitials) ?? "KK",
            avatarGradientColors: [grad1, grad2],
            accountType: AccountType(rawValue: defaults.string(forKey: Key.accountType) ?? "kid") ?? .kid,
            memberSince: Date(),
            xp: 0,
            balance: 0,
            totalEarned: 0,
            totalSaved: 0,
            choresCompleted: 0,
            notificationsEnabled: true,
            choreRemindersEnabled: true,
            savingsAlertsEnabled: true,
            avatarEmoji: defaults.string(forKey: Key.avatarEmoji) ?? "🚀",
            accentColorHex: defaults.string(forKey: Key.accentColorHex) ?? "#29C76A"
        )
    }

    // MARK: Mock / sample data

    @MainActor
    static let sample = User(
        name: "Kiwee Kid",
        avatarInitials: "KK",
        avatarGradientColors: [Color(red: 0.15, green: 0.25, blue: 0.55), Color(red: 0.30, green: 0.50, blue: 0.95)],
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
        avatarEmoji: "🚀",
        accentColorHex: "#4D80F2"
    )

    /// Alias used by `HomeViewModel`.
    @MainActor static let mock = sample
}

// MARK: - Color hex helpers

extension Color {
    /// Create a Color from a hex string like "#4D80F2".
    init?(hex: String) {
        let cleaned = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        guard cleaned.count == 6,
              let value = UInt64(cleaned, radix: 16) else { return nil }
        let r = Double((value >> 16) & 0xFF) / 255.0
        let g = Double((value >> 8) & 0xFF) / 255.0
        let b = Double(value & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }

    /// Convert this color to a hex string.
    var hexString: String {
        let components = UIColor(self).cgColor.components ?? [0, 0, 0]
        let r = Int((components[0]) * 255)
        let g = Int((components[safe: 1] ?? 0) * 255)
        let b = Int((components[safe: 2] ?? 0) * 255)
        return String(format: "#%02X%02X%02X", r, g, b)
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
