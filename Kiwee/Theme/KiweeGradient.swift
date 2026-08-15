import SwiftUI

// MARK: - Decorative Gradient Helpers

extension KiweeAvatar {

    /// A decorative gradient from this avatar's hero to a complementary
    /// avatar's hero color (from spec §22).
    ///
    /// Use for hero sections, avatar backgrounds, celebrations, and
    /// marketing graphics. **Never** use behind dense financial data.
    var decorativeGradient: LinearGradient {
        LinearGradient(
            colors: [scale.hero, gradientPartner.scale.hero],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    /// A subtle intra-scale gradient from s400 → s600, useful for
    /// card accents, row backgrounds, and depth effects.
    var intraGradient: LinearGradient {
        LinearGradient(
            colors: [scale.s400.opacity(0.25), scale.s600.opacity(0.15)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    /// A very soft background gradient using the deepest tones.
    /// Suitable for hero card backgrounds without overwhelming content.
    var softBackgroundGradient: LinearGradient {
        LinearGradient(
            colors: [scale.s900.opacity(0.3), scale.s800.opacity(0.15)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    // MARK: - Gradient Partners (spec §22)

    /// The complementary avatar for cross-avatar gradients.
    private var gradientPartner: KiweeAvatar {
        switch self {
        case .poppy:   return .gigi     // pink → purple
        case .kiwi:    return .forest   // lime → green
        case .bubbles: return .blu      // cyan → blue
        case .gigi:    return .poppy    // purple → pink
        case .mango:   return .poppy    // orange → pink
        case .sunny:   return .mango    // yellow → orange
        case .roxy:    return .gigi     // red → purple
        case .blu:     return .bubbles  // blue → cyan
        case .forest:  return .kiwi    // green → lime
        case .sky:     return .blu      // sky → blue
        }
    }
}
