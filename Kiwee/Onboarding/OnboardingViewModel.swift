import SwiftUI

// MARK: - Onboarding ViewModel

/// Drives the onboarding flow state: current step, selections, navigation.
///
/// Answers persist across back/forward navigation. The view model owns
/// the flow data and exposes computed properties for the current step's
/// UI state (headline, options, CTA enablement, progress).
@Observable @MainActor
final class OnboardingViewModel {

    // ── Flow data ───────────────────────────────────────────────────────

    let steps: [OnboardingStep]

    /// Index of the currently displayed step.
    var currentIndex: Int = 0

    /// Accumulated selections keyed by step id.
    var selections: [String: Set<String>] = [:]

    /// Set to `true` when the user completes the final step.
    var isComplete: Bool = false

    // ── Init ────────────────────────────────────────────────────────────

    init(steps: [OnboardingStep] = OnboardingStep.defaultFlow) {
        self.steps = steps
    }

    // ── Current step ────────────────────────────────────────────────────

    var currentStep: OnboardingStep { steps[currentIndex] }
    var isFirstStep: Bool { currentIndex == 0 }
    var isLastStep: Bool { currentIndex == steps.count - 1 }

    /// Fraction filled for the progress bar (0…1).
    var progress: Double {
        Double(currentIndex + 1) / Double(steps.count)
    }

    /// The selections for the current step.
    var currentSelections: Set<String> {
        get { selections[currentStep.id] ?? [] }
        set { selections[currentStep.id] = newValue }
    }

    /// Whether the CTA is enabled (enough selections made).
    var canContinue: Bool {
        currentSelections.count >= currentStep.minSelect
    }

    /// CTA label text.
    var ctaLabel: String {
        canContinue
            ? "Continue"
            : "Pick \(currentStep.minSelect) or more to continue"
    }

    // ── Actions ─────────────────────────────────────────────────────────

    /// Toggle an option's selection for the current step.
    func toggle(_ optionID: String) {
        if currentStep.type == .singleSelect || currentStep.type == .avatarPicker {
            // Single-select: replace selection
            currentSelections = [optionID]
        } else {
            // Multi-select: toggle
            if currentSelections.contains(optionID) {
                currentSelections.remove(optionID)
            } else {
                currentSelections.insert(optionID)
            }
        }
    }

    /// Check if an option is selected.
    func isSelected(_ optionID: String) -> Bool {
        currentSelections.contains(optionID)
    }

    /// Advance to the next step, or complete if on the last step.
    func advance() {
        guard canContinue else { return }
        if isLastStep {
            isComplete = true
        } else {
            currentIndex += 1
        }
    }

    /// Go back one step.
    func goBack() {
        guard !isFirstStep else { return }
        currentIndex -= 1
    }
}
