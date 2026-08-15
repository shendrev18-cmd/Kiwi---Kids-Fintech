import SwiftUI

/// A reusable tab bar component that wraps the native iOS 26 `TabView`
/// with `Tab` items to get the authentic Liquid Glass treatment.
///
/// The tab bar tint uses the user's accent color from their avatar selection.
struct KiweeGlassTabBar: View {
    @Binding var selectedTab: KiweeTab
    @Environment(User.self) private var user

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
        .tint(user.accentColor)
    }
}

// MARK: - Preview

#Preview("Kiwee Glass Tab Bar") {
    KiweeGlassTabBar(selectedTab: .constant(.home))
        .environment(User.sample)
        .preferredColorScheme(.dark)
}
