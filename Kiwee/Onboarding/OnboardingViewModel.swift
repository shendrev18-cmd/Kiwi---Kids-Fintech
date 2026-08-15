import SwiftUI

// MARK: - AvatarOption

/// A character avatar with an emoji and a seed color that drives the app's theme.
struct AvatarOption: Identifiable, Sendable {
    let id: String
    let label: String
    let emoji: String
    /// Hex seed color authored by design — drives the dynamic theme.
    let seedColor: String

    static let presets: [AvatarOption] = [
        AvatarOption(id: "astronaut",  label: "Astronaut",  emoji: "🚀", seedColor: "#4D80F2"),
        AvatarOption(id: "dinosaur",   label: "Dinosaur",   emoji: "🦖", seedColor: "#4DCC66"),
        AvatarOption(id: "unicorn",    label: "Unicorn",    emoji: "🦄", seedColor: "#D972E6"),
        AvatarOption(id: "pirate",     label: "Pirate",     emoji: "🏴‍☠️", seedColor: "#E69933"),
        AvatarOption(id: "superhero",  label: "Superhero",  emoji: "🦸", seedColor: "#F24D59"),
        AvatarOption(id: "ninja",      label: "Ninja",      emoji: "🥷", seedColor: "#8C8CA6"),
        AvatarOption(id: "mermaid",    label: "Mermaid",    emoji: "🧜", seedColor: "#33CCD9"),
        AvatarOption(id: "robot",      label: "Robot",      emoji: "🤖", seedColor: "#66B3F2"),
        AvatarOption(id: "dragon",     label: "Dragon",     emoji: "🐉", seedColor: "#F27333"),
        AvatarOption(id: "wizard",     label: "Wizard",     emoji: "🧙", seedColor: "#8C59E6"),
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

/// Drives the entire onboarding flow: step navigation, user input, validation,
/// and the dynamic theme that changes color when the avatar is selected.
@Observable
@MainActor
final class OnboardingViewModel {
    // MARK: Theme

    let theme = DynamicTheme()

    // MARK: Step navigation

    var currentStep: OnboardingStep = .welcome

    // MARK: User input

    var userName: String = ""
    var selectedAvatar: AvatarOption = AvatarOption.presets[0] {
        didSet {
            // Animate the theme seed change
            withAnimation(.easeOut(duration: 0.4)) {
                theme.seedHex = selectedAvatar.seedColor
            }
        }
    }
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
        case .avatar:       true
        case .accountType:  true
        case .firstGoal:    goalTargetAmount > 0
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
        let hsl = theme.hexToHSL(selectedAvatar.seedColor)
        let gradientDark = theme.hslToColor(h: hsl.h, s: min(max(hsl.s, 0.60), 0.85), l: 0.25)
        let gradientLight = theme.hslToColor(h: hsl.h, s: min(max(hsl.s, 0.60), 0.85), l: 0.52)

        return User(
            name: userName.trimmingCharacters(in: .whitespacesAndNewlines),
            avatarInitials: avatarInitials,
            avatarGradientColors: [gradientDark, gradientLight],
            accountType: selectedAccountType,
            memberSince: Date(),
            xp: 0,
            totalEarned: 0,
            totalSaved: 0,
            choresCompleted: 0,
            notificationsEnabled: true,
            choreRemindersEnabled: true,
            savingsAlertsEnabled: true,
            avatarEmoji: selectedAvatar.emoji,
            accentColorHex: selectedAvatar.seedColor
        )
    }
}
