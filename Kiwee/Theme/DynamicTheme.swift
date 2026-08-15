import SwiftUI

// MARK: - DynamicTheme

/// Runtime theme object driven by a single seed color (from the selected avatar).
/// All tokens recompute when the seed changes. Never hardcode hex values in components.
@Observable
@MainActor
final class DynamicTheme {
    /// The seed hex that drives all derived tokens.
    var seedHex: String {
        didSet { recompute() }
    }

    // MARK: Derived tokens

    /// Full-chroma accent for icons, active states, buttons.
    private(set) var accent: Color = .clear
    /// Gradient stop 1 — bottom of screen, brightest.
    private(set) var glowWarm: Color = .clear
    /// Gradient stop 2 — mid-screen.
    private(set) var glowMid: Color = .clear
    /// Top of screen, near-black with a faint hue tint.
    private(set) var surfaceBase: Color = .clear
    /// Option card fill.
    private(set) var surfaceCard: Color = .clear
    /// Near-white text.
    private(set) var textPrimary: Color = Color(white: 0.95)
    /// ~60% opacity text.
    private(set) var textSecondary: Color = Color(white: 0.95).opacity(0.6)

    /// Default seed: Kiwee green.
    static let defaultSeed = "#29C76A"

    init(seedHex: String = DynamicTheme.defaultSeed) {
        self.seedHex = seedHex
        recompute()
    }

    // MARK: Derive tokens from seed

    private func recompute() {
        let hsl = hexToHSL(seedHex)

        // accent — seed at full chroma
        accent = hslToColor(h: hsl.h, s: hsl.s, l: max(hsl.l, 0.45))

        // glow-warm — same hue, saturation 60–85%, lightness ~52%
        let warmS = min(max(hsl.s, 0.60), 0.85)
        glowWarm = hslToColor(h: hsl.h, s: warmS, l: 0.52)

        // glow-mid — same hue, saturation ~45%, lightness ~24%
        glowMid = hslToColor(h: hsl.h, s: 0.45, l: 0.24)

        // surface-base — same hue, saturation max 12%, lightness 6%
        surfaceBase = hslToColor(h: hsl.h, s: min(hsl.s, 0.12), l: 0.06)

        // surface-card — slightly lighter than base
        surfaceCard = Color(white: 0.12).opacity(0.9)
    }

    // MARK: HSL utilities

    struct HSL {
        let h: Double  // 0–360
        let s: Double  // 0–1
        let l: Double  // 0–1
    }

    func hexToHSL(_ hex: String) -> HSL {
        let cleaned = hex.replacingOccurrences(of: "#", with: "")
        guard cleaned.count == 6, let value = UInt64(cleaned, radix: 16) else {
            return HSL(h: 145, s: 0.7, l: 0.47) // fallback green
        }

        let r = Double((value >> 16) & 0xFF) / 255.0
        let g = Double((value >> 8) & 0xFF) / 255.0
        let b = Double(value & 0xFF) / 255.0

        let maxC = max(r, g, b)
        let minC = min(r, g, b)
        let delta = maxC - minC

        // Lightness
        let l = (maxC + minC) / 2.0

        guard delta > 0 else {
            return HSL(h: 0, s: 0, l: l)
        }

        // Saturation
        let s = l > 0.5 ? delta / (2.0 - maxC - minC) : delta / (maxC + minC)

        // Hue
        var h: Double
        if maxC == r {
            h = ((g - b) / delta).truncatingRemainder(dividingBy: 6)
        } else if maxC == g {
            h = (b - r) / delta + 2
        } else {
            h = (r - g) / delta + 4
        }
        h *= 60
        if h < 0 { h += 360 }

        return HSL(h: h, s: s, l: l)
    }

    func hslToColor(h: Double, s: Double, l: Double) -> Color {
        let c = (1 - abs(2 * l - 1)) * s
        let x = c * (1 - abs((h / 60).truncatingRemainder(dividingBy: 2) - 1))
        let m = l - c / 2

        let (r1, g1, b1): (Double, Double, Double)
        switch h {
        case 0..<60:    (r1, g1, b1) = (c, x, 0)
        case 60..<120:  (r1, g1, b1) = (x, c, 0)
        case 120..<180: (r1, g1, b1) = (0, c, x)
        case 180..<240: (r1, g1, b1) = (0, x, c)
        case 240..<300: (r1, g1, b1) = (x, 0, c)
        default:        (r1, g1, b1) = (c, 0, x)
        }

        return Color(red: r1 + m, green: g1 + m, blue: b1 + m)
    }
}
