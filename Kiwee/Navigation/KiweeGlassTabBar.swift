import SwiftUI

/// Wraps the native iOS 26 `TabView` with `Tab` items for the Liquid Glass treatment.
///
/// `selectedTab` is threaded as a `@Binding` into `HomeView` and `ProfileView`
/// so those screens can switch tabs programmatically (CTA buttons, stat taps).
struct KiweeGlassTabBar: View {
    @Binding var selectedTab: KiweeTab

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(KiweeTab.home.title, systemImage: KiweeTab.home.icon, value: .home) {
                HomeView(selectedTab: $selectedTab)
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
                ProfileView(selectedTab: $selectedTab)
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        // Tint is applied by ContentView, seeded from the kid's avatar gradient color
    }
}

// MARK: - Preview

#Preview("Kiwee Glass Tab Bar") {
    KiweeGlassTabBar(selectedTab: .constant(.home))
        .environment(User.sample)
        .environment(AppSession())
}
