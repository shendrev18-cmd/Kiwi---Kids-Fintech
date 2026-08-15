import SwiftUI

// MARK: - AvatarGradientOption

/// Preset gradient color pairs for the avatar picker.
struct AvatarGradientOption: Identifiable, Sendable {
    let id: String
    let label: String
    let colors: [Color]

    static let presets: [AvatarGradientOption] = [
        AvatarGradientOption(id: "berry",    label: "Berry",    colors: [.pink, .purple]),
        AvatarGradientOption(id: "ocean",    label: "Ocean",    colors: [.blue, .teal]),
        AvatarGradientOption(id: "forest",   label: "Forest",   colors: [.green, .mint]),
        AvatarGradientOption(id: "sunset",   label: "Sunset",   colors: [.orange, .red]),
        AvatarGradientOption(id: "gold",     label: "Gold",     colors: [.yellow, .orange]),
        AvatarGradientOption(id: "lavender", label: "Lavender", colors: [.purple, .indigo]),
        AvatarGradientOption(id: "coral",    label: "Coral",    colors: [.pink, .orange]),
        AvatarGradientOption(id: "kiwee",    label: "Kiwee",    colors: [Color.kiweeGreen, Color.kiweeTeal]),
    ]
}

// MARK: - GoalIconOption

/// Preset icons for the first savings goal.
struct GoalIconOption: Identifiable, Sendable {
    let id: String
    let symbol: String
    let label: String

    static let presets: [GoalIconOption] = [
        GoalIconOption(id: "star",       symbol: "star.fill",              label: "Star"),
        GoalIconOption(id: "game",       symbol: "gamecontroller.fill",    label: "Game"),
        GoalIconOption(id: "bicycle",    symbol: "bicycle",                label: "Bike"),
        GoalIconOption(id: "book",       symbol: "book.fill",              label: "Book"),
        GoalIconOption(id: "gift",       symbol: "gift.fill",              label: "Gift"),
        GoalIconOption(id: "tshirt",     symbol: "tshirt.fill",            label: "Clothes"),
        GoalIconOption(id: "music",      symbol: "headphones",             label: "Music"),
        GoalIconOption(id: "toy",        symbol: "teddybear.fill",         label: "Toy"),
    ]
}

// MARK: - OnboardingViewModel

/// Drives the entire onboarding flow: step navigation, user input, and validation.
@Observable
@MainActor
final class OnboardingViewModel {
    // MARK: Step navigation

    var currentStep: OnboardingStep = .welcome

    // MARK: User input

    var userName: String = ""
    var selectedGradient: AvatarGradientOption = AvatarGradientOption.presets[0]
    var selectedAccountType: AccountType = .kid

    // Goal input (name is optional — falls back to icon label)
    var goalName: String = ""
    var goalTargetAmount: Double = 25.0
    var selectedGoalIcon: GoalIconOption = GoalIconOption.presets[0]

    /// The display name for the goal: user-entered name, or the icon label as fallback.
    var resolvedGoalName: String {
        let trimmed = goalName.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? selectedGoalIcon.label : trimmed
    }

    // Feature tour sub-page
    var tourPage: Int = 0

    // MARK: Computed properties

    /// Initials derived from the entered name (first letter of first two words, or first two chars).
    var avatarInitials: String {
        let trimmed = userName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return "KK" }

        let words = trimmed.split(separator: " ")
        if words.count >= 2,
           let first = words[0].first,
           let second = words[1].first {
            return String([first, second]).uppercased()
        }
        let chars = Array(trimmed.prefix(2))
        return String(chars).uppercased()
    }

    /// Progress from 0.0 to 1.0 through the onboarding steps.
    var progress: Double {
        Double(currentStep.index) / Double(OnboardingStep.totalSteps - 1)
    }

    var isFirstStep: Bool { currentStep == .welcome }
    var isLastStep: Bool  { currentStep == .celebration }

    /// Whether the current step has enough input to proceed.
    var canAdvance: Bool {
        switch currentStep {
        case .welcome:      true
        case .name:         !userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case .avatar:       true  // has default selection
        case .accountType:  true  // has default selection
        case .firstGoal:    goalTargetAmount > 0  // name is optional
        case .featureTour:  true
        case .celebration:  true
        }
    }

    // MARK: Navigation

    func next() {
        guard let nextIndex = OnboardingStep(rawValue: currentStep.rawValue + 1) else { return }
        withAnimation(.easeInOut(duration: 0.35)) {
            currentStep = nextIndex
        }
    }

    func back() {
        guard currentStep.allowsBack,
              let prevIndex = OnboardingStep(rawValue: currentStep.rawValue - 1) else { return }
        withAnimation(.easeInOut(duration: 0.35)) {
            currentStep = prevIndex
        }
    }

    // MARK: Build final user

    /// Creates a `User` from the collected onboarding data.
    func buildUser() -> User {
        User(
            name: userName.trimmingCharacters(in: .whitespacesAndNewlines),
            avatarInitials: avatarInitials,
            avatarGradientColors: selectedGradient.colors,
            accountType: selectedAccountType,
            memberSince: Date(),
            xp: 0,
            totalEarned: 0,
            totalSaved: 0,
            choresCompleted: 0,
            notificationsEnabled: true,
            choreRemindersEnabled: true,
            savingsAlertsEnabled: true,
            appearanceMode: .system
        )
    }
}
