import SwiftUI
import UIKit

// MARK: - Kiwee Custom Fonts
//
// Primary:   Lexend   — headings, large numerals, nav titles, tab bar labels
// Secondary: Figtree  — body, captions, supporting text, default app font
//
// Both ship as variable-weight TTFs registered in Info.plist via UIAppFonts.
// SwiftUI: .weight(_:) selects the wght axis on Font.custom.
// UIKit:   UIFontDescriptor.withFamily picks the registered family; bold trait
//          shifts the weight axis automatically on iOS 16+.

// MARK: - SwiftUI Font helpers

extension Font {
    // ── Primary: Lexend ──────────────────────────────────────────────────────

    /// Lexend scaled to a Dynamic Type text style (accessibility-safe).
    static func lexend(_ style: TextStyle, weight: Weight = .regular) -> Font {
        .custom("Lexend", size: style.defaultSize, relativeTo: style).weight(weight)
    }

    /// Lexend at a fixed point size (prefer the `relativeTo:` variant).
    static func lexend(size: CGFloat, weight: Weight = .regular) -> Font {
        .custom("Lexend", size: size).weight(weight)
    }

    // ── Secondary: Figtree ───────────────────────────────────────────────────

    /// Figtree scaled to a Dynamic Type text style (accessibility-safe).
    static func figtree(_ style: TextStyle, weight: Weight = .regular) -> Font {
        .custom("Figtree", size: style.defaultSize, relativeTo: style).weight(weight)
    }

    /// Figtree at a fixed point size (prefer the `relativeTo:` variant).
    static func figtree(size: CGFloat, weight: Weight = .regular) -> Font {
        .custom("Figtree", size: size).weight(weight)
    }
}

// MARK: - TextStyle default sizes

private extension Font.TextStyle {
    /// Default point sizes matching Apple's Human Interface Guidelines.
    var defaultSize: CGFloat {
        switch self {
        case .largeTitle:  34
        case .title:       28
        case .title2:      22
        case .title3:      20
        case .headline:    17
        case .body:        17
        case .callout:     16
        case .subheadline: 15
        case .footnote:    13
        case .caption:     12
        case .caption2:    11
        @unknown default:  17
        }
    }
}

// MARK: - UIFont helpers (for UIAppearance / UIKit APIs)

extension UIFont {
    // ── Primary: Lexend ──────────────────────────────────────────────────────

    static func lexend(size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        let base = UIFontDescriptor().withFamily("Lexend")
        let descriptor: UIFontDescriptor
        switch weight {
        case .bold, .heavy, .black:
            descriptor = base.withSymbolicTraits(.traitBold) ?? base
        default:
            descriptor = base
        }
        return UIFont(descriptor: descriptor.withSize(size), size: 0)
    }

    // ── Secondary: Figtree ───────────────────────────────────────────────────

    static func figtree(size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        let base = UIFontDescriptor().withFamily("Figtree")
        let descriptor: UIFontDescriptor
        switch weight {
        case .bold, .heavy, .black:
            descriptor = base.withSymbolicTraits(.traitBold) ?? base
        default:
            descriptor = base
        }
        return UIFont(descriptor: descriptor.withSize(size), size: 0)
    }
}

// MARK: - App-wide UIAppearance configuration

extension KiweeApp {
    /// Call once from `KiweeApp.init()` to stamp both fonts into every
    /// system-managed surface (navigation bars, tab bars) before any view loads.
    static func configureAppearance() {
        configureNavigationBar()
        configureTabBar()
    }

    // MARK: Navigation bar — Lexend
    private static func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()

        // Large title  — Lexend Bold (34 pt)
        appearance.largeTitleTextAttributes = [
            .font: UIFont.lexend(size: 34, weight: .bold)
        ]

        // Inline/compact title — Lexend SemiBold (17 pt)
        let inlineDescriptor = UIFontDescriptor().withFamily("Lexend")
        let inlineFont = UIFont(
            descriptor: inlineDescriptor
                .addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.semibold]])
                .withSize(17),
            size: 0
        )
        appearance.titleTextAttributes = [.font: inlineFont]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }

    // MARK: Tab bar — Figtree
    private static func configureTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()

        // Label attributes for both normal and selected states
        let labelFont = UIFont.figtree(size: 10, weight: .medium)
        let normal   = [NSAttributedString.Key.font: labelFont]
        let selected = [NSAttributedString.Key.font: labelFont]

        for item in [appearance.stackedLayoutAppearance,
                     appearance.inlineLayoutAppearance,
                     appearance.compactInlineLayoutAppearance] {
            item.normal.titleTextAttributes   = normal
            item.selected.titleTextAttributes = selected
        }

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
