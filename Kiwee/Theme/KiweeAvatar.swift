import SwiftUI

// MARK: - Color Scale

/// A 10-step tonal scale for an avatar color (50 → 900).
///
/// - `s500` is the **hero** color (primary identity).
/// - `s50–s200` are the lightest tints.
/// - `s300–s400` are expressive / saturated treatments.
/// - `s600–s900` are dark surfaces, gradients, borders, and overlays.
struct KiweeColorScale: Sendable {
    let s50:  Color
    let s100: Color
    let s200: Color
    let s300: Color
    let s400: Color
    let s500: Color
    let s600: Color
    let s700: Color
    let s800: Color
    let s900: Color

    /// The hero / primary identity color (same as `s500`).
    var hero: Color { s500 }

    /// Access a scale step by numeric value (50, 100, … 900).
    subscript(step: Int) -> Color {
        switch step {
        case 50:  return s50
        case 100: return s100
        case 200: return s200
        case 300: return s300
        case 400: return s400
        case 500: return s500
        case 600: return s600
        case 700: return s700
        case 800: return s800
        case 900: return s900
        default:  return s500
        }
    }
}

// MARK: - Avatar Enum

/// The 10 Kiwee personality avatars, each with a unique color identity.
///
/// When a user selects an avatar, the avatar's `scale` becomes the source
/// of all personal color tokens throughout the app.
enum KiweeAvatar: String, CaseIterable, Identifiable, Sendable {
    case poppy
    case kiwi
    case bubbles
    case gigi
    case mango
    case sunny
    case roxy
    case blu
    case forest
    case sky

    var id: String { rawValue }

    /// Human-readable name for display.
    var displayName: String {
        switch self {
        case .poppy:   return "Poppy"
        case .kiwi:    return "Kiwi"
        case .bubbles: return "Bubbles"
        case .gigi:    return "Gigi"
        case .mango:   return "Mango"
        case .sunny:   return "Sunny"
        case .roxy:    return "Roxy"
        case .blu:     return "Blu"
        case .forest:  return "Forest"
        case .sky:     return "Sky"
        }
    }

    /// One-line personality description.
    var personality: String {
        switch self {
        case .poppy:   return "Bold. Social. Full of energy."
        case .kiwi:    return "Growth. Savings. Optimism."
        case .bubbles: return "Curious. Digital. Explorative."
        case .gigi:    return "Creative. Iconic. A little extra."
        case .mango:   return "Warm. Adventurous. Fun."
        case .sunny:   return "Optimistic. Cheerful. Positive."
        case .roxy:    return "Fearless. Confident. Bold."
        case .blu:     return "Calm. Focused. Collected."
        case .forest:  return "Grounded. Steady. Strong."
        case .sky:     return "Light. Open. Limitless."
        }
    }

    /// The glow color for atmospheric effects (from spec §23).
    var glowColor: Color {
        switch self {
        case .poppy:   return Color(.sRGB, red: 1.00, green: 0.25, blue: 0.64, opacity: 0.20)
        case .kiwi:    return Color(.sRGB, red: 0.72, green: 0.95, blue: 0.23, opacity: 0.18)
        case .bubbles: return Color(.sRGB, red: 0.21, green: 0.91, blue: 1.00, opacity: 0.18)
        case .gigi:    return Color(.sRGB, red: 0.61, green: 0.42, blue: 1.00, opacity: 0.20)
        case .mango:   return Color(.sRGB, red: 1.00, green: 0.54, blue: 0.24, opacity: 0.18)
        case .sunny:   return Color(.sRGB, red: 1.00, green: 0.83, blue: 0.23, opacity: 0.18)
        case .roxy:    return Color(.sRGB, red: 1.00, green: 0.30, blue: 0.40, opacity: 0.18)
        case .blu:     return Color(.sRGB, red: 0.30, green: 0.49, blue: 1.00, opacity: 0.18)
        case .forest:  return Color(.sRGB, red: 0.13, green: 0.77, blue: 0.37, opacity: 0.18)
        case .sky:     return Color(.sRGB, red: 0.56, green: 0.83, blue: 1.00, opacity: 0.18)
        }
    }

    // MARK: - Color Scales

    /// The full 10-step tonal scale for this avatar.
    ///
    /// Each scale is hand-tuned from the hero (500) hex value.
    /// Lighter steps (50–400) tint toward white in HSB space.
    /// Darker steps (600–900) shade toward black, preserving hue.
    var scale: KiweeColorScale {
        switch self {

        // 01 — POPPY  Hero: #FF3FA4
        case .poppy:
            return KiweeColorScale(
                s50:  Color(hex: 0xFFF0F7),
                s100: Color(hex: 0xFFD6EA),
                s200: Color(hex: 0xFFADD5),
                s300: Color(hex: 0xFF80BF),
                s400: Color(hex: 0xFF5CB0),
                s500: Color(hex: 0xFF3FA4),
                s600: Color(hex: 0xD9358C),
                s700: Color(hex: 0xB32B73),
                s800: Color(hex: 0x80204F),
                s900: Color(hex: 0x4D1330)
            )

        // 02 — KIWI  Hero: #B8F23A
        case .kiwi:
            return KiweeColorScale(
                s50:  Color(hex: 0xF5FDEA),
                s100: Color(hex: 0xE6FAC5),
                s200: Color(hex: 0xD4F79E),
                s300: Color(hex: 0xC6F472),
                s400: Color(hex: 0xBEF354),
                s500: Color(hex: 0xB8F23A),
                s600: Color(hex: 0x9ACD30),
                s700: Color(hex: 0x7AA826),
                s800: Color(hex: 0x577A1B),
                s900: Color(hex: 0x354D10)
            )

        // 03 — BUBBLES  Hero: #35E8FF
        case .bubbles:
            return KiweeColorScale(
                s50:  Color(hex: 0xEBFCFF),
                s100: Color(hex: 0xC5F6FF),
                s200: Color(hex: 0x9CF0FF),
                s300: Color(hex: 0x6FEEFF),
                s400: Color(hex: 0x4EEBFF),
                s500: Color(hex: 0x35E8FF),
                s600: Color(hex: 0x2CC4D9),
                s700: Color(hex: 0x239FB3),
                s800: Color(hex: 0x197280),
                s900: Color(hex: 0x10464D)
            )

        // 04 — GIGI  Hero: #9B6CFF
        case .gigi:
            return KiweeColorScale(
                s50:  Color(hex: 0xF3EEFF),
                s100: Color(hex: 0xDFD1FF),
                s200: Color(hex: 0xCBB3FF),
                s300: Color(hex: 0xB595FF),
                s400: Color(hex: 0xA87FFF),
                s500: Color(hex: 0x9B6CFF),
                s600: Color(hex: 0x835BD9),
                s700: Color(hex: 0x6B4AB3),
                s800: Color(hex: 0x4D3580),
                s900: Color(hex: 0x30204D)
            )

        // 05 — MANGO  Hero: #FF8A3D
        case .mango:
            return KiweeColorScale(
                s50:  Color(hex: 0xFFF4EB),
                s100: Color(hex: 0xFFDFC5),
                s200: Color(hex: 0xFFC89C),
                s300: Color(hex: 0xFFAF70),
                s400: Color(hex: 0xFF9C55),
                s500: Color(hex: 0xFF8A3D),
                s600: Color(hex: 0xD97534),
                s700: Color(hex: 0xB3602B),
                s800: Color(hex: 0x80451F),
                s900: Color(hex: 0x4D2A13)
            )

        // 06 — SUNNY  Hero: #FFD43B
        case .sunny:
            return KiweeColorScale(
                s50:  Color(hex: 0xFFFBEB),
                s100: Color(hex: 0xFFF3C5),
                s200: Color(hex: 0xFFEA9C),
                s300: Color(hex: 0xFFE070),
                s400: Color(hex: 0xFFDA55),
                s500: Color(hex: 0xFFD43B),
                s600: Color(hex: 0xD9B432),
                s700: Color(hex: 0xB39429),
                s800: Color(hex: 0x806B1E),
                s900: Color(hex: 0x4D4012)
            )

        // 07 — ROXY  Hero: #FF4D67
        case .roxy:
            return KiweeColorScale(
                s50:  Color(hex: 0xFFF0F2),
                s100: Color(hex: 0xFFD1D8),
                s200: Color(hex: 0xFFADB9),
                s300: Color(hex: 0xFF8595),
                s400: Color(hex: 0xFF667A),
                s500: Color(hex: 0xFF4D67),
                s600: Color(hex: 0xD94158),
                s700: Color(hex: 0xB33548),
                s800: Color(hex: 0x802633),
                s900: Color(hex: 0x4D1720)
            )

        // 08 — BLU  Hero: #4D7CFF
        case .blu:
            return KiweeColorScale(
                s50:  Color(hex: 0xEDF2FF),
                s100: Color(hex: 0xCFDAFF),
                s200: Color(hex: 0xAFC1FF),
                s300: Color(hex: 0x8DA7FF),
                s400: Color(hex: 0x6D91FF),
                s500: Color(hex: 0x4D7CFF),
                s600: Color(hex: 0x4169D9),
                s700: Color(hex: 0x3556B3),
                s800: Color(hex: 0x263E80),
                s900: Color(hex: 0x18264D)
            )

        // 09 — FOREST  Hero: #22C55E
        case .forest:
            return KiweeColorScale(
                s50:  Color(hex: 0xECFDF3),
                s100: Color(hex: 0xC8F7DC),
                s200: Color(hex: 0xA0F0C3),
                s300: Color(hex: 0x72E8A5),
                s400: Color(hex: 0x49D87F),
                s500: Color(hex: 0x22C55E),
                s600: Color(hex: 0x1DA750),
                s700: Color(hex: 0x188941),
                s800: Color(hex: 0x12632F),
                s900: Color(hex: 0x0B3C1C)
            )

        // 10 — SKY  Hero: #8FD3FF
        case .sky:
            return KiweeColorScale(
                s50:  Color(hex: 0xF0F8FF),
                s100: Color(hex: 0xD6EDFF),
                s200: Color(hex: 0xBBE1FF),
                s300: Color(hex: 0xA3D9FF),
                s400: Color(hex: 0x99D6FF),
                s500: Color(hex: 0x8FD3FF),
                s600: Color(hex: 0x79B3D9),
                s700: Color(hex: 0x6393B3),
                s800: Color(hex: 0x486A80),
                s900: Color(hex: 0x2D404D)
            )
        }
    }
}
