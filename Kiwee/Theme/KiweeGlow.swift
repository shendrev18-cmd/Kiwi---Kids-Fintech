import SwiftUI

// MARK: - Glow Intensity

/// Glow intensity levels for the Kiwee atmospheric effect.
enum KiweeGlowIntensity: Sendable {
    /// Subtle ambient glow (spec default: 0.18–0.20 opacity).
    case subtle
    /// Medium emphasis glow.
    case medium
    /// Strong highlight glow (avatar selection, celebrations).
    case strong

    var opacity: Double {
        switch self {
        case .subtle: return 0.18
        case .medium: return 0.35
        case .strong: return 0.55
        }
    }
}

// MARK: - Glow ViewModifier

/// Applies the current avatar's glow color as a shadow effect.
///
/// Usage:
/// ```swift
/// Circle()
///     .kiweeGlow()
///
/// Image(systemName: "star.fill")
///     .kiweeGlow(radius: 30, intensity: .strong)
/// ```
struct KiweeGlowModifier: ViewModifier {
    @Environment(KiweeTheme.self) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var radius: CGFloat
    var intensity: KiweeGlowIntensity

    func body(content: Content) -> some View {
        content.shadow(
            color: theme.personalGlow.opacity(intensity.opacity),
            radius: reduceMotion ? radius * 0.5 : radius
        )
    }
}

extension View {
    /// Applies the current avatar's glow as an atmospheric shadow effect.
    ///
    /// - Parameters:
    ///   - radius: Blur radius for the glow. Default `20`.
    ///   - intensity: `.subtle` (default), `.medium`, or `.strong`.
    func kiweeGlow(
        radius: CGFloat = 20,
        intensity: KiweeGlowIntensity = .subtle
    ) -> some View {
        modifier(KiweeGlowModifier(radius: radius, intensity: intensity))
    }
}
