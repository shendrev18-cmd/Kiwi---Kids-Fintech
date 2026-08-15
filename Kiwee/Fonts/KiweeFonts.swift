import SwiftUI
import UIKit

// MARK: - Kiwee Custom Fonts
//
// Three typefaces with clearly defined responsibilities:
//
// LEXEND    = BRAND + PERSONALITY
//             Hero headlines, page titles, headings, onboarding,
//             personalized greetings, avatar names, primary CTAs.
//
// INTER     = INFORMATION + FINANCE
//             Account balances, transaction amounts/descriptions, dates,
//             numbers, forms, body copy, settings, legal content.
//
// FIGTREE   = UTILITY + LABELS + MICROCOPY
//             Labels, overlines, navigation labels, status badges,
//             categories, metadata, ALL CAPS text, short utility text.
//
// All three ship as variable-weight TTFs registered in Info.plist via UIAppFonts.

// MARK: - SwiftUI Font helpers

extension Font {
    // ── Primary: Lexend ──────────────────────────────────────────────────────

    /// Lexend scaled to a Dynamic Type text style (accessibility-safe).
    static func lexend(_ style: TextStyle, weight: Weight = .regular) -> Font {
        .custom("Lexend", size: defaultSize(for: style), relativeTo: style).weight(weight)
    }

    /// Lexend at a fixed point size (prefer the `relativeTo:` variant).
    static func lexend(size: CGFloat, weight: Weight = .regular) -> Font {
        .custom("Lexend", size: size).weight(weight)
    }

    // ── Secondary: Inter ────────────────────────────────────────────────────

    /// Inter scaled to a Dynamic Type text style (accessibility-safe).
    static func inter(_ style: TextStyle, weight: Weight = .regular) -> Font {
        .custom("Inter Variable", size: defaultSize(for: style), relativeTo: style).weight(weight)
    }

    /// Inter at a fixed point size (prefer the `relativeTo:` variant).
    static func inter(size: CGFloat, weight: Weight = .regular) -> Font {
        .custom("Inter Variable", size: size).weight(weight)
    }

    // ── Tertiary: Figtree ───────────────────────────────────────────────────

    /// Figtree scaled to a Dynamic Type text style (accessibility-safe).
    static func figtree(_ style: TextStyle, weight: Weight = .regular) -> Font {
        .custom("Figtree", size: defaultSize(for: style), relativeTo: style).weight(weight)
    }

    /// Figtree at a fixed point size (prefer the `relativeTo:` variant).
    static func figtree(size: CGFloat, weight: Weight = .regular) -> Font {
        .custom("Figtree", size: size).weight(weight)
    }

    // ── Default point sizes for Dynamic Type styles ─────────────────────

    /// The default point size for each text style (matches Apple's HIG).
    /// Used as the base size for `Font.custom(_:size:relativeTo:)`.
    private static func defaultSize(for style: TextStyle) -> CGFloat {
        switch style {
        case .largeTitle:  return 34
        case .title:       return 28
        case .title2:      return 22
        case .title3:      return 20
        case .headline:    return 17
        case .body:        return 17
        case .callout:     return 16
        case .subheadline: return 15
        case .footnote:    return 13
        case .caption:     return 12
        case .caption2:    return 11
        @unknown default:  return 17
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

    // ── Secondary: Inter ────────────────────────────────────────────────────

    static func inter(size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        let base = UIFontDescriptor().withFamily("Inter Variable")
        let descriptor: UIFontDescriptor
        switch weight {
        case .bold, .heavy, .black:
            descriptor = base.withSymbolicTraits(.traitBold) ?? base
        default:
            descriptor = base
        }
        return UIFont(descriptor: descriptor.withSize(size), size: 0)
    }

    // ── Tertiary: Figtree ───────────────────────────────────────────────────

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
    /// Call once from `KiweeApp.init()` to stamp fonts into every
    /// system-managed surface (navigation bars, tab bars) before any view loads.
    static func configureAppearance() {
        configureNavigationBar()
        configureTabBar()
    }

    // MARK: Navigation bar — Lexend (brand voice)
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

    // MARK: Tab bar — Figtree (utility/navigation labels)
    private static func configureTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()

        // Navigation labels use Figtree per spec §13
        let normalFont = UIFont.figtree(size: 10, weight: .medium)
        let selectedFont = UIFont.figtree(size: 10, weight: .bold)
        let normal   = [NSAttributedString.Key.font: normalFont]
        let selected = [NSAttributedString.Key.font: selectedFont]

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
