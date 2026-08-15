import SwiftUI
import UIKit

// MARK: - WCAG Contrast Utilities

/// Utilities for computing WCAG 2.2 contrast ratios and choosing
/// accessible foreground colors on arbitrary backgrounds.
enum KiweeContrast {

    /// Returns `.black` (#000000) or `.white` (#FFFFFF) — whichever provides
    /// the higher WCAG contrast ratio against `background`.
    ///
    /// Used primarily for dynamic button text on avatar-colored backgrounds.
    /// The spec defaults to black when sufficient contrast exists, falling
    /// back to white otherwise.
    static func accessibleForeground(on background: Color) -> Color {
        let luminance = relativeLuminance(of: background)

        // WCAG contrast ratio formula: (L_lighter + 0.05) / (L_darker + 0.05)
        let contrastWithBlack = (luminance + 0.05) / 0.05
        let contrastWithWhite = 1.05 / (luminance + 0.05)

        return contrastWithBlack >= contrastWithWhite
            ? Color(hex: 0x000000)
            : Color(hex: 0xFFFFFF)
    }

    /// The WCAG 2.2 relative luminance of a color, in the range [0, 1].
    ///
    /// Uses the sRGB linearization formula and the standard luminance
    /// coefficients: 0.2126 R + 0.7152 G + 0.0722 B.
    static func relativeLuminance(of color: Color) -> Double {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        UIColor(color).getRed(&r, green: &g, blue: &b, alpha: &a)

        let rLinear = linearize(Double(r))
        let gLinear = linearize(Double(g))
        let bLinear = linearize(Double(b))

        return 0.2126 * rLinear + 0.7152 * gLinear + 0.0722 * bLinear
    }

    /// WCAG contrast ratio between two colors, always ≥ 1.
    static func contrastRatio(_ color1: Color, _ color2: Color) -> Double {
        let l1 = relativeLuminance(of: color1)
        let l2 = relativeLuminance(of: color2)
        let lighter = max(l1, l2)
        let darker  = min(l1, l2)
        return (lighter + 0.05) / (darker + 0.05)
    }

    // MARK: - Private

    /// sRGB → linear channel conversion per WCAG 2.2.
    private static func linearize(_ channel: Double) -> Double {
        channel <= 0.04045
            ? channel / 12.92
            : pow((channel + 0.055) / 1.055, 2.4)
    }
}
