import SwiftUI

// MARK: - OnboardingButton

/// Full-width capsule button for the dark onboarding flow.
/// Uses the dynamic accent color from the selected avatar.
struct OnboardingButton: View {
    let label: String
    var accentColor: Color = .kiweeGreen
    var style: Style = .primary
    var isEnabled: Bool = true
    let action: () -> Void

    enum Style {
        case primary
        case secondary
    }

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.lexend(.headline, weight: .semibold))
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .foregroundStyle(foregroundColor)
                .background(background)
                .clipShape(Capsule())
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1 : 0.35)
    }

    private var foregroundColor: Color {
        switch style {
        case .primary:   .white
        case .secondary: accentColor
        }
    }

    @ViewBuilder
    private var background: some View {
        switch style {
        case .primary:   accentColor
        case .secondary: Color.white.opacity(0.08)
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        OnboardingButton(label: "Get Started", action: {})
        OnboardingButton(label: "Next", accentColor: .purple, action: {})
        OnboardingButton(label: "Next", isEnabled: false, action: {})
        OnboardingButton(label: "Skip", style: .secondary, action: {})
    }
    .padding()
    .background(Color(red: 0.06, green: 0.06, blue: 0.10))
    .preferredColorScheme(.dark)
}
