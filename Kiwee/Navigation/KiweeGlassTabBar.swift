import SwiftUI

/// A reusable tab bar component that wraps the native iOS 26 `TabView`
/// with `Tab` items to get the authentic Liquid Glass treatment.
///
/// The system automatically provides:
/// - Floating translucent glass capsule
/// - Morphing selection indicator that slides between items
/// - Minimize-on-scroll behavior (shrinks to a compact pill)
/// - Adaptive light/dark glass material
/// - Full VoiceOver, Dynamic Type, and Reduce Motion support
/// - Proper safe area handling for all iPhone geometries
///
/// Navigation state is driven by the bound `KiweeTab` value, keeping
/// the model layer cleanly separated from the visual component.
struct KiweeGlassTabBar: View {
    @Binding var selectedTab: KiweeTab
    @Environment(KiweeTheme.self) private var theme

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(KiweeTab.home.title, systemImage: KiweeTab.home.icon, value: .home) {
                HomeView()
            }

            Tab(KiweeTab.activity.title, systemImage: KiweeTab.activity.icon, value: .activity) {
                ActivityView()
            }

            Tab(KiweeTab.earn.title, systemImage: KiweeTab.earn.icon, value: .earn) {
                EarnView()
            }

            Tab(KiweeTab.save.title, systemImage: KiweeTab.save.icon, value: .save) {
                SaveView()
            }

            Tab(KiweeTab.profile.title, systemImage: KiweeTab.profile.icon, value: .profile) {
                ProfileView()
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .tint(theme.navActive)
    }
}

// MARK: - Preview

#Preview("Kiwee Glass Tab Bar") {
    KiweeGlassTabBar(selectedTab: .constant(.home))
}
