import SwiftUI

// MARK: - Kiwee Custom Fonts
//
// Primary:   Lexend   — headings, large numerals, titles
// Secondary: Figtree  — body rows, captions, labels, supporting text
//
// Both are variable-weight TTFs; `.weight(_:)` selects the weight axis
// at runtime, so a single registered family covers all weights.

extension Font {
    // ── Primary: Lexend ──────────────────────────────────────────────────────

    /// Lexend scaled to a Dynamic Type text style (accessibility-safe).
    static func lexend(_ style: TextStyle, weight: Weight = .regular) -> Font {
        .custom("Lexend", relativeTo: style).weight(weight)
    }

    /// Lexend at a fixed point size (prefer the `relativeTo:` variant).
    static func lexend(size: CGFloat, weight: Weight = .regular) -> Font {
        .custom("Lexend", size: size).weight(weight)
    }

    // ── Secondary: Figtree ───────────────────────────────────────────────────

    /// Figtree scaled to a Dynamic Type text style (accessibility-safe).
    static func figtree(_ style: TextStyle, weight: Weight = .regular) -> Font {
        .custom("Figtree", relativeTo: style).weight(weight)
    }

    /// Figtree at a fixed point size (prefer the `relativeTo:` variant).
    static func figtree(size: CGFloat, weight: Weight = .regular) -> Font {
        .custom("Figtree", size: size).weight(weight)
    }
}
