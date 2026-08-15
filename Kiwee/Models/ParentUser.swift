import SwiftUI

// MARK: - PaymentMethodType

enum PaymentMethodType: String, CaseIterable, Sendable {
    case bankAccount
    case debitCard
    case creditCard

    var label: String {
        switch self {
        case .bankAccount: "Bank Account"
        case .debitCard:   "Debit Card"
        case .creditCard:  "Credit Card"
        }
    }

    var icon: String {
        switch self {
        case .bankAccount: "building.columns"
        case .debitCard:   "creditcard"
        case .creditCard:  "creditcard.fill"
        }
    }
}

// MARK: - PaymentMethod

struct PaymentMethod: Identifiable, Sendable {
    let id: UUID
    let type: PaymentMethodType
    let institutionName: String
    /// Always masked — e.g. "•••• 4242". Full numbers are never stored here.
    let maskedNumber: String
    var isDefault: Bool
}

// MARK: - ChildAccount

struct ChildAccount: Identifiable, Sendable {
    let id: UUID
    let name: String
    let initials: String
    let gradientStart: Color
    let gradientEnd: Color
    var isPaused: Bool
    var balance: Double
    var choresCompleted: Int
}

// MARK: - CoParentAccess

enum CoParentAccess: String, CaseIterable, Sendable {
    case viewOnly = "View Only"
    case full     = "Full Access"

    var icon: String {
        switch self {
        case .viewOnly: "eye"
        case .full:     "checkmark.shield"
        }
    }
}

// MARK: - CoParent

struct CoParent: Identifiable, Sendable {
    let id: UUID
    let name: String
    let email: String
    var accessLevel: CoParentAccess
    var isAccepted: Bool
}

// MARK: - FamilyTransactionType

enum FamilyTransactionType: Sendable {
    case chore
    case allowance
    case purchase
    case reload

    var label: String {
        switch self {
        case .chore:     "Chore"
        case .allowance: "Allowance"
        case .purchase:  "Purchase"
        case .reload:    "Reload"
        }
    }

    var icon: String {
        switch self {
        case .chore:     "checkmark.circle.fill"
        case .allowance: "gift.fill"
        case .purchase:  "cart.fill"
        case .reload:    "arrow.clockwise.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .chore:     .orange
        case .allowance: .green
        case .purchase:  .red
        case .reload:    .blue
        }
    }
}

// MARK: - FamilyTransaction

struct FamilyTransaction: Identifiable, Sendable {
    let id: UUID
    let childName: String
    let description: String
    let amount: Double      // positive = credit, negative = debit
    let date: Date
    let type: FamilyTransactionType
}

// MARK: - ParentUser

@Observable
@MainActor
final class ParentUser {
    var name: String
    var avatarInitials: String
    var avatarGradientColors: [Color]
    var phone: String
    var email: String

    // Money
    var paymentMethods: [PaymentMethod]
    var autoReloadEnabled: Bool
    var autoReloadTopUpAmount: Double   // amount to top up
    var autoReloadThreshold: Double     // trigger threshold
    var transactions: [FamilyTransaction]

    // Family
    var children: [ChildAccount]
    var coParents: [CoParent]

    // Notifications
    var notifyApprovalRequests: Bool
    var notifyChoreCompletions: Bool
    var notifyAllowanceSent: Bool
    var notifyLowBalance: Bool
    var notifyWeeklyDigest: Bool

    // Security
    var requireAuthForPayments: Bool
    var biometricEnabled: Bool
    var hasPIN: Bool

    // Appearance
    var appearanceMode: AppearanceMode

    init(
        name: String,
        avatarInitials: String,
        avatarGradientColors: [Color],
        phone: String,
        email: String,
        paymentMethods: [PaymentMethod],
        autoReloadEnabled: Bool,
        autoReloadTopUpAmount: Double,
        autoReloadThreshold: Double,
        transactions: [FamilyTransaction],
        children: [ChildAccount],
        coParents: [CoParent],
        notifyApprovalRequests: Bool,
        notifyChoreCompletions: Bool,
        notifyAllowanceSent: Bool,
        notifyLowBalance: Bool,
        notifyWeeklyDigest: Bool,
        requireAuthForPayments: Bool,
        biometricEnabled: Bool,
        hasPIN: Bool,
        appearanceMode: AppearanceMode
    ) {
        self.name = name
        self.avatarInitials = avatarInitials
        self.avatarGradientColors = avatarGradientColors
        self.phone = phone
        self.email = email
        self.paymentMethods = paymentMethods
        self.autoReloadEnabled = autoReloadEnabled
        self.autoReloadTopUpAmount = autoReloadTopUpAmount
        self.autoReloadThreshold = autoReloadThreshold
        self.transactions = transactions
        self.children = children
        self.coParents = coParents
        self.notifyApprovalRequests = notifyApprovalRequests
        self.notifyChoreCompletions = notifyChoreCompletions
        self.notifyAllowanceSent = notifyAllowanceSent
        self.notifyLowBalance = notifyLowBalance
        self.notifyWeeklyDigest = notifyWeeklyDigest
        self.requireAuthForPayments = requireAuthForPayments
        self.biometricEnabled = biometricEnabled
        self.hasPIN = hasPIN
        self.appearanceMode = appearanceMode
    }

    var childrenCount: Int { children.count }

    @MainActor
    static let sample: ParentUser = {
        let now = Date()
        let day: TimeInterval = 86_400

        return ParentUser(
            name: "Alex Parent",
            avatarInitials: "AP",
            avatarGradientColors: [.blue, .teal],
            phone: "+1 (555) 012-3456",
            email: "alex@example.com",
            paymentMethods: [
                PaymentMethod(
                    id: UUID(),
                    type: .bankAccount,
                    institutionName: "Community Bank",
                    maskedNumber: "•••• 6789",
                    isDefault: true
                ),
                PaymentMethod(
                    id: UUID(),
                    type: .debitCard,
                    institutionName: "Kiwee Visa",
                    maskedNumber: "•••• 4242",
                    isDefault: false
                ),
            ],
            autoReloadEnabled: true,
            autoReloadTopUpAmount: 50,
            autoReloadThreshold: 20,
            transactions: [
                FamilyTransaction(id: UUID(), childName: "Kiwee Kid",  description: "Weekly Allowance",  amount:  10.00, date: now,               type: .allowance),
                FamilyTransaction(id: UUID(), childName: "Kiwee Kid",  description: "Took Out Trash",    amount:   2.00, date: now - day,          type: .chore),
                FamilyTransaction(id: UUID(), childName: "Little Sis", description: "Allowance",         amount:   5.00, date: now - 2 * day,      type: .allowance),
                FamilyTransaction(id: UUID(), childName: "Kiwee Kid",  description: "Bookshop",          amount:  -6.75, date: now - 3 * day,      type: .purchase),
                FamilyTransaction(id: UUID(), childName: "Little Sis", description: "Cleaned Kitchen",   amount:   3.00, date: now - 3 * day,      type: .chore),
                FamilyTransaction(id: UUID(), childName: "Kiwee Kid",  description: "Auto-Reload",       amount:  50.00, date: now - 5 * day,      type: .reload),
                FamilyTransaction(id: UUID(), childName: "Little Sis", description: "Weekly Allowance",  amount:   5.00, date: now - 7 * day,      type: .allowance),
                FamilyTransaction(id: UUID(), childName: "Kiwee Kid",  description: "Mowed Lawn",        amount:   5.00, date: now - 8 * day,      type: .chore),
            ],
            children: [
                ChildAccount(id: UUID(), name: "Kiwee Kid",  initials: "KK", gradientStart: .pink,   gradientEnd: .purple, isPaused: false, balance: 142.50, choresCompleted: 24),
                ChildAccount(id: UUID(), name: "Little Sis", initials: "LS", gradientStart: .orange, gradientEnd: .yellow, isPaused: false, balance: 28.00,  choresCompleted: 11),
            ],
            coParents: [
                CoParent(id: UUID(), name: "Jordan Parent", email: "jordan@example.com", accessLevel: .full, isAccepted: true),
            ],
            notifyApprovalRequests: true,
            notifyChoreCompletions: true,
            notifyAllowanceSent: true,
            notifyLowBalance: true,
            notifyWeeklyDigest: false,
            requireAuthForPayments: true,
            biometricEnabled: true,
            hasPIN: true,
            appearanceMode: .system
        )
    }()
}
