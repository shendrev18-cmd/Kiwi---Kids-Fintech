import SwiftUI

/// The five navigation destinations in the Kiwee app.
///
/// Keeps navigation identity separate from the visual tab bar so
/// any view can read or set the selected tab without coupling to
/// `KiweeGlassTabBar`.
enum KiweeTab: String, CaseIterable, Identifiable, Sendable {
    case home
    case activity
    case earn
    case save
    case profile

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home:     "Home"
        case .activity: "Activity"
        case .earn:     "Earn"
        case .save:     "Save"
        case .profile:  "Profile"
        }
    }

    /// Outlined SF Symbol — no filled variants.
    var icon: String {
        switch self {
        case .home:     "house"
        case .activity: "arrow.left.arrow.right"
        case .earn:     "piggybank"
        case .save:     "target"
        case .profile:  "person"
        }
    }
}
