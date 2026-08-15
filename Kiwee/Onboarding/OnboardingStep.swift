import SwiftUI

// MARK: - Onboarding Data Model
//
// The flow is data-driven: an array of `OnboardingStep` configs,
// not N hardcoded screens. Each step declares its type, headline,
// options, and minimum selection count.

/// A single step in the onboarding flow.
struct OnboardingStep: Identifiable, Sendable {
    let id: String
    let headline: String
    let subtitle: String
    let type: StepType
    let options: [OptionItem]
    let minSelect: Int

    enum StepType: Sendable {
        /// Multi-select checkboxes (pick ≥ minSelect).
        case multiSelect
        /// Single-select radio (pick exactly 1).
        case singleSelect
        /// Avatar picker grid.
        case avatarPicker
    }
}

/// An option within a step.
struct OptionItem: Identifiable, Hashable, Sendable {
    let id: String
    let label: String
    let emoji: String
}

// MARK: - Default Onboarding Steps

extension OnboardingStep {
    /// The complete onboarding flow for Kiwee.
    static let defaultFlow: [OnboardingStep] = [
        // Step 1: Choose your Kiwee avatar
        OnboardingStep(
            id: "avatar",
            headline: "Choose your Kiwee",
            subtitle: "Pick the one that feels like you",
            type: .avatarPicker,
            options: [], // Avatar picker uses KiweeAvatar.allCases directly
            minSelect: 1
        ),

        // Step 2: What do you want to do with Kiwee?
        OnboardingStep(
            id: "goals",
            headline: "What do you want\nto do with Kiwee?",
            subtitle: "Pick 1 or more",
            type: .multiSelect,
            options: [
                OptionItem(id: "save",    label: "Save for something special",   emoji: "🎯"),
                OptionItem(id: "earn",    label: "Earn money from chores",       emoji: "💪"),
                OptionItem(id: "spend",   label: "Track my spending",            emoji: "📊"),
                OptionItem(id: "learn",   label: "Learn about money",            emoji: "🧠"),
                OptionItem(id: "invest",  label: "Start investing early",        emoji: "📈"),
            ],
            minSelect: 1
        ),

        // Step 3: How do you earn money?
        OnboardingStep(
            id: "income",
            headline: "How do you get\nyour money?",
            subtitle: "Select all that apply",
            type: .multiSelect,
            options: [
                OptionItem(id: "allowance", label: "Weekly allowance",         emoji: "💵"),
                OptionItem(id: "chores",    label: "Chores and tasks",         emoji: "🧹"),
                OptionItem(id: "birthday",  label: "Birthday & holiday gifts", emoji: "🎁"),
                OptionItem(id: "job",       label: "Part-time job",            emoji: "💼"),
                OptionItem(id: "other",     label: "Other",                    emoji: "✨"),
            ],
            minSelect: 1
        ),

        // Step 4: What are you saving for?
        OnboardingStep(
            id: "saving_for",
            headline: "What are you\nsaving for?",
            subtitle: "Pick your top goals",
            type: .multiSelect,
            options: [
                OptionItem(id: "tech",      label: "Tech & gadgets",     emoji: "📱"),
                OptionItem(id: "fashion",   label: "Clothes & fashion",  emoji: "👟"),
                OptionItem(id: "gaming",    label: "Games & gaming",     emoji: "🎮"),
                OptionItem(id: "travel",    label: "Travel & adventures", emoji: "✈️"),
                OptionItem(id: "music",     label: "Music & concerts",   emoji: "🎵"),
                OptionItem(id: "surprise",  label: "I'll decide later",  emoji: "🤷"),
            ],
            minSelect: 1
        ),
    ]
}
