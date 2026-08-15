import SwiftUI

// MARK: - Theme Object

/// The central theme object that drives Kiwee's avatar-based color system.
///
/// When a user selects an avatar, setting `theme.avatar` automatically
/// propagates the new personal color through every token. Views read
/// tokens via `@Environment(KiweeTheme.self)`.
///
/// Foundation colors (`KiweeColor.*`) and semantic colors are **fixed** —
/// they never change with the avatar. Only the personal and component
/// tokens derived from `avatar.scale` change.
@Observable @MainActor
final class KiweeTheme {

    /// The currently selected avatar. Changing this updates all personal
    /// and component tokens system-wide.
    var avatar: KiweeAvatar = .kiwi

    // ── Personal Tokens ─────────────────────────────────────────────────

    /// The hero identity color (scale 500).
    var personalPrimary: Color { avatar.scale.hero }

    /// Medium-light expressive treatment (scale 300).
    var personalLight: Color { avatar.scale.s300 }

    /// Light accent (scale 200).
    var personalSoft: Color { avatar.scale.s200 }

    /// Dark surface / overlay (scale 700).
    var personalDark: Color { avatar.scale.s700 }

    /// Deepest overlay / selected card background (scale 900).
    var personalDeep: Color { avatar.scale.s900 }

    /// Atmospheric glow color (per-avatar rgba from spec §23).
    var personalGlow: Color { avatar.glowColor }

    // ── Button Tokens ───────────────────────────────────────────────────

    /// Primary CTA background — avatar hero.
    var buttonBackground: Color { avatar.scale.hero }

    /// Primary CTA text — black or white for maximum contrast.
    var buttonText: Color { KiweeContrast.accessibleForeground(on: avatar.scale.hero) }

    /// Primary CTA hover state (scale 400).
    var buttonHover: Color { avatar.scale.s400 }

    /// Primary CTA pressed state (scale 600).
    var buttonPressed: Color { avatar.scale.s600 }

    /// Disabled button background.
    var buttonDisabledBackground: Color { KiweeColor.surface4 }

    /// Disabled button text.
    var buttonDisabledText: Color { KiweeColor.textTertiary }

    // ── Navigation Tokens ───────────────────────────────────────────────

    /// Active tab/nav icon and indicator — avatar hero.
    var navActive: Color { avatar.scale.hero }

    /// Inactive tab/nav icon.
    var navInactive: Color { KiweeColor.textTertiary }

    /// Active tab/nav label text.
    var navActiveLabel: Color { KiweeColor.textPrimary }

    // ── Card Tokens ─────────────────────────────────────────────────────

    /// Default card background.
    var cardBackground: Color { KiweeColor.surface1 }

    /// Default card border.
    var cardBorder: Color { KiweeColor.border }

    /// Interactive card border — avatar hero.
    var cardInteractiveBorder: Color { avatar.scale.hero }

    /// Interactive card hover border (scale 400).
    var cardHoverBorder: Color { avatar.scale.s400 }

    /// Selected card background — deepest avatar tone at controlled opacity.
    var cardSelected: Color { avatar.scale.s900 }

    // ── Input Tokens ────────────────────────────────────────────────────

    /// Input focus border — avatar hero.
    var inputFocus: Color { avatar.scale.hero }

    /// Input error border.
    var inputError: Color { KiweeColor.error }

    /// Input success border.
    var inputSuccess: Color { KiweeColor.success }

    // ── Progress Tokens ─────────────────────────────────────────────────

    /// Progress bar track.
    var progressTrack: Color { KiweeColor.surface4 }

    /// Progress bar filled value — avatar hero.
    var progressValue: Color { avatar.scale.hero }

    /// Goal completion accent (scale 400).
    var progressGoal: Color { avatar.scale.s400 }

    // ── Link Tokens ─────────────────────────────────────────────────────

    /// Default link color (scale 400 or 300 depending on contrast).
    var linkDefault: Color { avatar.scale.s400 }

    /// Link hover (scale 300).
    var linkHover: Color { avatar.scale.s300 }

    /// Link pressed (scale 600).
    var linkPressed: Color { avatar.scale.s600 }
}

// MARK: - Environment Integration
//
// Uses the @Observable-native pattern: `.environment(theme)` to inject,
// `@Environment(KiweeTheme.self) var theme` to read.
// No custom EnvironmentKey needed — SwiftUI registers Observable types
// automatically by their concrete type.
