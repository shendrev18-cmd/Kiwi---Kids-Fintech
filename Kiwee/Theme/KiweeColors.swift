import SwiftUI

// MARK: - Color(hex:) Initializer

extension Color {
    /// Create a color from a hex integer, e.g. `Color(hex: 0xFF3FA4)`.
    init(hex: UInt, opacity: Double = 1.0) {
        self.init(
            red:   Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8)  & 0xFF) / 255.0,
            blue:  Double( hex        & 0xFF) / 255.0,
            opacity: opacity
        )
    }
}

// MARK: - Foundation & Semantic Color Tokens

/// Fixed color tokens that never change regardless of the selected avatar.
///
/// Two categories live here:
/// 1. **Foundation** — backgrounds, surfaces, borders, text grays
/// 2. **Semantic** — success, warning, error, info (functional meaning)
///
/// Usage: `KiweeColor.background`, `KiweeColor.success`, etc.
enum KiweeColor {

    // ── Backgrounds ─────────────────────────────────────────────────────────

    /// Primary app background — pure black (#000000).
    static let background = Color(hex: 0x000000)

    /// Surface level 1 — darkest card/row background (#080808).
    static let surface1   = Color(hex: 0x080808)

    /// Surface level 2 — slightly lifted surface (#0D0D0D).
    static let surface2   = Color(hex: 0x0D0D0D)

    /// Surface level 3 — mid-elevation surface (#171717).
    static let surface3   = Color(hex: 0x171717)

    /// Surface level 4 — highest neutral surface (#242424).
    static let surface4   = Color(hex: 0x242424)

    // ── Borders ─────────────────────────────────────────────────────────────

    /// Default border color (#242424).
    static let border       = Color(hex: 0x242424)

    /// Strong / emphasized border (#333333).
    static let borderStrong = Color(hex: 0x333333)

    // ── Text ────────────────────────────────────────────────────────────────

    /// Primary text — pure white (#FFFFFF).
    static let textPrimary   = Color(hex: 0xFFFFFF)

    /// Secondary text — light gray (#B7B7C2).
    static let textSecondary = Color(hex: 0xB7B7C2)

    /// Tertiary text — medium gray (#777784).
    static let textTertiary  = Color(hex: 0x777784)

    /// Disabled text — dark gray (#44444D).
    static let textDisabled  = Color(hex: 0x44444D)

    // ── Semantic ────────────────────────────────────────────────────────────

    /// Success / Income / Savings (#22C55E).
    static let success = Color(hex: 0x22C55E)

    /// Warning / Pending (#FFD43B).
    static let warning = Color(hex: 0xFFD43B)

    /// Error / Declined / Destructive (#FF4D67).
    static let error   = Color(hex: 0xFF4D67)

    /// Information / Refund (#35E8FF).
    static let info    = Color(hex: 0x35E8FF)
}
