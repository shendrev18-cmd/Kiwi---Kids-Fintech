import Foundation

// MARK: - OnboardingStep

/// Each screen in the first-launch onboarding flow.
enum OnboardingStep: Int, CaseIterable, Sendable {
    case welcome
    case name
    case avatar
    case accountType
    case firstGoal
    case featureTour
    case celebration

    // MARK: Display metadata

    var title: String {
        switch self {
        case .welcome:      "Welcome to Kiwee!"
        case .name:         "What's your name?"
        case .avatar:       "Create your avatar"
        case .accountType:  "Who are you?"
        case .firstGoal:    "Set your first goal"
        case .featureTour:  "Here's what you can do"
        case .celebration:  "You're all set!"
        }
    }

    var subtitle: String {
        switch self {
        case .welcome:      "The fun way to earn, save, and spend."
        case .name:         "Tell us what we should call you."
        case .avatar:       "Pick your colors and we'll make it yours."
        case .accountType:  "Let us know so we can personalize your experience."
        case .firstGoal:    "What are you saving up for?"
        case .featureTour:  "Swipe to see what Kiwee has in store."
        case .celebration:  "Your Kiwee account is ready to go!"
        }
    }

    // MARK: Navigation behavior

    var allowsBack: Bool {
        switch self {
        case .welcome, .celebration: false
        default: true
        }
    }

    var buttonLabel: String {
        switch self {
        case .welcome:     "Get Started"
        case .celebration: "Let's Go!"
        default:           "Next"
        }
    }

    // MARK: Helpers

    var index: Int { rawValue }

    static var totalSteps: Int { allCases.count }
}
