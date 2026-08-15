import SwiftUI

// MARK: - Primary Button Style

/// The Kiwee primary CTA button style, driven by the current avatar theme.
///
/// - **Default**: Avatar hero background with accessible text (black or white).
/// - **Pressed**: Avatar scale 600 (darker).
/// - **Disabled**: Surface 4 background with tertiary text.
/// - **Focus**: Avatar hero + visible focus ring.
///
/// Usage:
/// ```swift
/// Button("Send Money") { … }
///     .buttonStyle(.kiweePrimary)
/// ```
struct KiweePrimaryButtonStyle: ButtonStyle {
    @Environment(KiweeTheme.self) private var theme
    @Environment(\.isEnabled) private var isEnabled
    @FocusState private var isFocused: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.kiwee(.buttonPrimary))
            .foregroundStyle(isEnabled ? theme.buttonText : theme.buttonDisabledText)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(backgroundColor(isPressed: configuration.isPressed))
            )
            .overlay {
                if isFocused {
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(KiweeColor.textPrimary, lineWidth: 2)
                        .padding(-2)
                }
            }
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
            .focusable()
            .focused($isFocused)
    }

    private func backgroundColor(isPressed: Bool) -> Color {
        if !isEnabled {
            return theme.buttonDisabledBackground
        }
        return isPressed ? theme.buttonPressed : theme.buttonBackground
    }
}

// MARK: - ButtonStyle Extension

extension ButtonStyle where Self == KiweePrimaryButtonStyle {
    /// The Kiwee primary CTA button style, themed by the current avatar.
    static var kiweePrimary: KiweePrimaryButtonStyle { KiweePrimaryButtonStyle() }
}
