import SwiftUI

// MARK: - Typography Tokens
//
// Semantic typography tokens that map every text role in the app to a
// specific typeface, size, weight, and line spacing.
//
// Three typefaces, three responsibilities:
//   LEXEND  = Brand + Personality (headings, CTAs, greetings)
//   INTER   = Information + Finance (body, amounts, forms, descriptions)
//   FIGTREE = Utility + Labels + Microcopy (labels, overlines, badges, nav)
//
// Usage:
//   Text("Hey, Alex")
//       .font(.kiwee(.heading1))
//
//   Text("$1,240.50")
//       .font(.kiwee(.balanceXL))

// MARK: - Token Enum

/// Every semantic text role in the Kiwee design system.
enum KiweeTextStyle {

    // ── Display ─────────────────────────────────────────────────────────
    /// 56 pt · Lexend 700 · Marketing hero, major brand moments
    case displayXL
    /// 48 pt · Lexend 700 · Hero titles, onboarding headlines
    case displayLarge
    /// 40 pt · Lexend 700 · Large mobile headlines, major dashboard moments
    case displayMedium

    // ── Headings ────────────────────────────────────────────────────────
    /// 32 pt · Lexend 700 · Primary screen titles
    case heading1
    /// 28 pt · Lexend 700 · Major sections
    case heading2
    /// 24 pt · Lexend 650 · Cards, important subsections
    case heading3
    /// 20 pt · Lexend 600 · Small sections, supporting card titles
    case heading4

    // ── Body (Inter) ────────────────────────────────────────────────────
    /// 18 pt · Inter 400 · Introductory descriptions, important supporting copy
    case bodyLarge
    /// 16 pt · Inter 400 · Default body / primary reading size
    case bodyMedium
    /// 14 pt · Inter 400 · Supporting information, secondary metadata
    case bodySmall

    // ── Financial (Inter) ───────────────────────────────────────────────
    /// 40 pt · Inter 700 · Primary balance display
    case balanceXL
    /// 32 pt · Inter 700 · Large balance
    case balanceLarge
    /// 24 pt · Inter 700 · Medium balance / card value
    case balanceMedium
    /// 16 pt · Inter 600 · Transaction amount
    case transactionAmount
    /// 14 pt · Inter 400 · Transaction date/category/metadata
    case transactionMeta

    // ── Labels (Figtree) ────────────────────────────────────────────────
    /// 14 pt · Figtree 600 · Card labels, form labels, categories
    case labelLarge
    /// 12 pt · Figtree 600 · Supporting labels, section identifiers
    case labelMedium
    /// 11 pt · Figtree 700 · Small utility text
    case labelSmall
    /// 11 pt · Figtree 700 · ALL CAPS overline (RECENT ACTIVITY, SAVINGS GOALS)
    case overline

    // ── Buttons ─────────────────────────────────────────────────────────
    /// 15 pt · Lexend 600 · Primary CTA
    case buttonPrimary
    /// 14 pt · Inter 600 · Secondary button
    case buttonSecondary
    /// 13 pt · Figtree 700 · Tertiary / text button
    case buttonTertiary

    // ── Navigation (Figtree) ────────────────────────────────────────────
    /// 13 pt · Figtree 600 · Active nav label
    case navActive
    /// 13 pt · Figtree 500 · Inactive nav label
    case navInactive

    // ── Status (Figtree) ────────────────────────────────────────────────
    /// 12 pt · Figtree 700 · Status badges (COMPLETED, PENDING, DECLINED)
    case status

    // ── Financial label (Figtree) ───────────────────────────────────────
    /// 12–14 pt · Figtree 600 · AVAILABLE BALANCE, etc.
    case financialLabel

    // ── Personalized greeting (Lexend) ──────────────────────────────────
    /// 28–32 pt · Lexend 700 · "Hey, Alex 👋"
    case greeting
}

// MARK: - Font + KiweeTextStyle

extension Font {
    /// Returns the `Font` for a Kiwee semantic text token.
    ///
    /// ```swift
    /// Text("$1,240.50")
    ///     .font(.kiwee(.balanceXL))
    /// ```
    static func kiwee(_ style: KiweeTextStyle) -> Font {
        switch style {

        // Display
        case .displayXL:
            return .lexend(size: 56, weight: .bold)
        case .displayLarge:
            return .lexend(size: 48, weight: .bold)
        case .displayMedium:
            return .lexend(size: 40, weight: .bold)

        // Headings
        case .heading1:
            return .lexend(size: 32, weight: .bold)
        case .heading2:
            return .lexend(size: 28, weight: .bold)
        case .heading3:
            return .lexend(size: 24, weight: .semibold)
        case .heading4:
            return .lexend(size: 20, weight: .semibold)

        // Body
        case .bodyLarge:
            return .inter(size: 18, weight: .regular)
        case .bodyMedium:
            return .inter(size: 16, weight: .regular)
        case .bodySmall:
            return .inter(size: 14, weight: .regular)

        // Financial
        case .balanceXL:
            return .inter(size: 40, weight: .bold)
        case .balanceLarge:
            return .inter(size: 32, weight: .bold)
        case .balanceMedium:
            return .inter(size: 24, weight: .bold)
        case .transactionAmount:
            return .inter(size: 16, weight: .semibold)
        case .transactionMeta:
            return .inter(size: 14, weight: .regular)

        // Labels
        case .labelLarge:
            return .figtree(size: 14, weight: .semibold)
        case .labelMedium:
            return .figtree(size: 12, weight: .semibold)
        case .labelSmall:
            return .figtree(size: 11, weight: .bold)
        case .overline:
            return .figtree(size: 11, weight: .bold)

        // Buttons
        case .buttonPrimary:
            return .lexend(size: 15, weight: .semibold)
        case .buttonSecondary:
            return .inter(size: 14, weight: .semibold)
        case .buttonTertiary:
            return .figtree(size: 13, weight: .bold)

        // Navigation
        case .navActive:
            return .figtree(size: 13, weight: .semibold)
        case .navInactive:
            return .figtree(size: 13, weight: .medium)

        // Status
        case .status:
            return .figtree(size: 12, weight: .bold)

        // Financial label
        case .financialLabel:
            return .figtree(size: 12, weight: .semibold)

        // Greeting
        case .greeting:
            return .lexend(size: 28, weight: .bold)
        }
    }
}
