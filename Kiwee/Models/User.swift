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
    // Identity
    var name: String
    var avatarInitials: String
    var avatarGradientColors: [Color]
    var accountType: AccountType
    var memberSince: Date

    // Gamification
    var xp: Int

    // Balances (lifetime totals drive the stats row)
    var balance: Double           // spending balance
    var totalEarned: Double       // lifetime earned
    var totalSaved: Double        // lifetime allocated to goals
    var choresCompleted: Int      // lifetime chore count
    var monthlyEarned: Double     // this-month earned (displayed on Earn banner)

    // Live data
    var chores: [Chore]
    var activityTransactions: [ActivityTransaction]
    var savingsGoals: [SavingsGoal]

    // Streak: 7 booleans Mon-Sun, true = completed a chore that day
    var streakDays: [Bool]

    // Auto-save
    var autoSavePercentage: Double   // 0–50 %

    // Notifications
    var notificationsEnabled: Bool
    var choreRemindersEnabled: Bool
    var savingsAlertsEnabled: Bool

    // Security
    var hasPIN: Bool
    var biometricEnabled: Bool

    // Appearance
    var appearanceMode: AppearanceMode

    // Family (read-only on kid side)
    var linkedParentNames: [String]

    // MARK: Computed

    var level: KiweeLevel { KiweeLevel.level(for: xp) }

    var savingsBalance: Double {
        savingsGoals.filter { !$0.isCompleted }.reduce(0) { $0 + $1.currentAmount }
    }

    var pendingChoresCount: Int {
        chores.filter { $0.status == .toDo }.count
    }

    // MARK: Init

    // swiftlint:disable function_parameter_count
    init(
        name: String,
        avatarInitials: String,
        avatarGradientColors: [Color],
        accountType: AccountType,
        memberSince: Date,
        xp: Int,
        balance: Double,
        totalEarned: Double,
        totalSaved: Double,
        choresCompleted: Int,
        monthlyEarned: Double,
        chores: [Chore],
        activityTransactions: [ActivityTransaction],
        savingsGoals: [SavingsGoal],
        streakDays: [Bool],
        autoSavePercentage: Double,
        notificationsEnabled: Bool,
        choreRemindersEnabled: Bool,
        savingsAlertsEnabled: Bool,
        hasPIN: Bool,
        biometricEnabled: Bool,
        appearanceMode: AppearanceMode,
        linkedParentNames: [String]
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
        self.monthlyEarned = monthlyEarned
        self.chores = chores
        self.activityTransactions = activityTransactions
        self.savingsGoals = savingsGoals
        self.streakDays = streakDays
        self.autoSavePercentage = autoSavePercentage
        self.notificationsEnabled = notificationsEnabled
        self.choreRemindersEnabled = choreRemindersEnabled
        self.savingsAlertsEnabled = savingsAlertsEnabled
        self.hasPIN = hasPIN
        self.biometricEnabled = biometricEnabled
        self.appearanceMode = appearanceMode
        self.linkedParentNames = linkedParentNames
    }
    // swiftlint:enable function_parameter_count

    // MARK: Sample

    @MainActor
    static let sample: User = {
        let cal = Calendar.current
        let jan2025 = cal.date(from: DateComponents(year: 2025, month: 1, day: 1))!
        let now = Date()
        let day: TimeInterval = 86_400

        // Chores
        let chores: [Chore] = [
            Chore(id: UUID(), title: "Take Out Trash",  amount: 1.00, category: .household, status: .toDo,            requiresPhoto: false, suggestedByKid: false, hasPhotoProof: false, dateCompleted: nil),
            Chore(id: UUID(), title: "Mow Lawn",        amount: 5.00, category: .outdoor,   status: .waitingOnParent, requiresPhoto: true,  suggestedByKid: false, hasPhotoProof: true,  dateCompleted: nil),
            Chore(id: UUID(), title: "Wash Dishes",     amount: 2.00, category: .household, status: .toDo,            requiresPhoto: false, suggestedByKid: false, hasPhotoProof: false, dateCompleted: nil),
            Chore(id: UUID(), title: "Walk the Dog",    amount: 3.00, category: .pet,       status: .approved,        requiresPhoto: false, suggestedByKid: false, hasPhotoProof: false, dateCompleted: now - day),
            Chore(id: UUID(), title: "Make Bed",        amount: 0.50, category: .household, status: .needsRedo,       requiresPhoto: false, suggestedByKid: false, hasPhotoProof: false, dateCompleted: nil),
            Chore(id: UUID(), title: "Read 30 min",     amount: 1.50, category: .academic,  status: .toDo,            requiresPhoto: false, suggestedByKid: false, hasPhotoProof: false, dateCompleted: nil),
        ]

        // Savings goals
        let bikeHistory: [GoalContribution] = [
            GoalContribution(id: UUID(), date: now - 7 * day,  amount:  25.00, note: "First deposit"),
            GoalContribution(id: UUID(), date: now - 3 * day,  amount:  15.00, note: "Moved from balance"),
            GoalContribution(id: UUID(), date: now - 1 * day,  amount:   5.00, note: "Weekly auto-save"),
        ]
        let goals: [SavingsGoal] = [
            SavingsGoal(id: UUID(), name: "New Bike",       emoji: "🚲", currentAmount: 45.00,  targetAmount: 120.00, createdDate: jan2025, isCompleted: false, history: bikeHistory),
            SavingsGoal(id: UUID(), name: "Headphones",     emoji: "🎧", currentAmount: 32.00,  targetAmount: 80.00,  createdDate: jan2025, isCompleted: false, history: []),
            SavingsGoal(id: UUID(), name: "Stuffed Animal", emoji: "🧸", currentAmount: 10.50,  targetAmount: 25.00,  createdDate: jan2025, isCompleted: false, history: []),
        ]

        // Activity transactions — real dates, real reason lines
        let txns: [ActivityTransaction] = [
            ActivityTransaction(id: UUID(), date: now,               title: "Weekly Allowance",   contextLine: "From parent · Every Sunday",             amount:  10.00, category: .earned,  status: .completed, hasPhotoProof: false, note: "", balanceBefore: 32.50,  balanceAfter: 42.50),
            ActivityTransaction(id: UUID(), date: now - 1 * day,    title: "Grocery Store",       contextLine: "Spent at local grocery",                 amount:  -4.50, category: .spent,   status: .completed, hasPhotoProof: false, note: "", balanceBefore: 37.00,  balanceAfter: 32.50),
            ActivityTransaction(id: UUID(), date: now - 1 * day,    title: "Moved to New Bike",   contextLine: "Savings transfer · New Bike goal",       amount: -15.00, category: .saved,   status: .completed, hasPhotoProof: false, note: "", balanceBefore: 52.00,  balanceAfter: 37.00),
            ActivityTransaction(id: UUID(), date: now - 2 * day,    title: "Walk the Dog",        contextLine: "Chore completed · Approved by parent",   amount:   3.00, category: .earned,  status: .completed, hasPhotoProof: false, note: "", balanceBefore: 49.00,  balanceAfter: 52.00),
            ActivityTransaction(id: UUID(), date: now - 2 * day,    title: "Mow Lawn",            contextLine: "Chore submitted · Waiting for approval", amount:   5.00, category: .earned,  status: .pending,   hasPhotoProof: true,  note: "", balanceBefore: 49.00,  balanceAfter: 49.00),
            ActivityTransaction(id: UUID(), date: now - 3 * day,    title: "Lunch",               contextLine: "Spent at school cafeteria",              amount:  -8.00, category: .spent,   status: .completed, hasPhotoProof: false, note: "", balanceBefore: 57.00,  balanceAfter: 49.00),
            ActivityTransaction(id: UUID(), date: now - 5 * day,    title: "Birthday Gift",       contextLine: "Gift from Grandma 🎂",                   amount:  25.00, category: .earned,  status: .completed, hasPhotoProof: false, note: "", balanceBefore: 32.00,  balanceAfter: 57.00),
            ActivityTransaction(id: UUID(), date: now - 7 * day,    title: "Moved to Headphones", contextLine: "Savings transfer · Headphones goal",     amount: -10.00, category: .saved,   status: .completed, hasPhotoProof: false, note: "", balanceBefore: 42.00,  balanceAfter: 32.00),
        ]

        return User(
            name: "Kiwee Kid",
            avatarInitials: "KK",
            avatarGradientColors: [.pink, .purple],
            accountType: .kid,
            memberSince: jan2025,
            xp: 340,
            balance: 42.50,
            totalEarned: 142.50,
            totalSaved: 87.50,
            choresCompleted: 24,
            monthlyEarned: 32.00,
            chores: chores,
            activityTransactions: txns,
            savingsGoals: goals,
            streakDays: [true, true, false, true, true, true, true],
            autoSavePercentage: 10,
            notificationsEnabled: true,
            choreRemindersEnabled: true,
            savingsAlertsEnabled: true,
            hasPIN: false,
            biometricEnabled: false,
            appearanceMode: .system,
            linkedParentNames: ["Alex Parent"]
        )
    }()
}
