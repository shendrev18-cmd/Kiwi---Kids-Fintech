import SwiftUI

// MARK: - KiweeTheme

/// Central design token namespace for the Kiwee app.
/// Use a caseless enum so it cannot be instantiated accidentally.
enum KiweeTheme {

    // MARK: Colors

    enum Colors {
        // Brand
        static let primary      = Color(red: 0.16, green: 0.78, blue: 0.42)  // Kiwee Green
        static let secondary    = Color(red: 0.07, green: 0.72, blue: 0.60)  // Kiwee Teal
        static let rewardGold   = Color(red: 1.00, green: 0.80, blue: 0.00)  // Earning yellow
        static let goalPurple   = Color(red: 0.70, green: 0.32, blue: 0.92)  // Savings purple
        static let actionOrange = Color(red: 1.00, green: 0.58, blue: 0.00)  // Action orange

        // Adaptive / semantic
        static let screenBackground = Color(.systemGroupedBackground)
        static let cardBackground   = Color(.secondarySystemGroupedBackground)

        /// Nine-color array for the 3×3 MeshGradient hero card.
        static let heroGradientColors: [Color] = [
            Color(red: 0.10, green: 0.80, blue: 0.44),
            Color(red: 0.08, green: 0.75, blue: 0.55),
            Color(red: 0.18, green: 0.88, blue: 0.48),
            Color(red: 0.12, green: 0.82, blue: 0.46),
            Color(red: 0.06, green: 0.70, blue: 0.58),
            Color(red: 0.20, green: 0.90, blue: 0.52),
            Color(red: 0.05, green: 0.68, blue: 0.50),
            Color(red: 0.04, green: 0.62, blue: 0.58),
            Color(red: 0.12, green: 0.76, blue: 0.44),
        ]
    }

    // MARK: Typography

    enum Typography {
        /// Large rounded balance display on the hero card.
        static let heroBalance = Font.system(size: 44, weight: .bold, design: .rounded)
        /// Section card title — medium weight, rounded.
        static let cardTitle   = Font.system(.subheadline, design: .rounded).weight(.semibold)
        /// Section header label.
        static let sectionHeader = Font.headline
    }

    // MARK: Spacing

    enum Spacing {
        /// Horizontal screen edge padding.
        static let screenH: CGFloat    = 20
        /// Vertical gap between top-level sections.
        static let sectionGap: CGFloat = 28
        /// Internal card padding.
        static let cardPad: CGFloat    = 16
        /// Gap between stacked cards within a section.
        static let cardSpacing: CGFloat = 10
    }

    // MARK: Radius

    enum Radius {
        /// Hero card corner radius.
        static let hero: CGFloat  = 28
        /// Standard card corner radius.
        static let card: CGFloat  = 20
        /// Icon badge corner radius.
        static let icon: CGFloat  = 12
    }
}

// MARK: - Color extensions

extension Color {
    static let kiweeGreen  = KiweeTheme.Colors.primary
    static let kiweeTeal   = KiweeTheme.Colors.secondary
}
