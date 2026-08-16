import SwiftUI

/// Root routing shell.
///
/// Reads `AppSession.role` and routes to:
///   - `nil`     → `RoleSelectView`
///   - `.kid`    → `KiweeGlassTabBar` tinted with the kid's avatar seed color
///   - `.parent` → `ParentProfileView`
struct ContentView: View {
    @Environment(AppSession.self) private var session
    @Environment(User.self) private var user
    @State private var selectedTab: KiweeTab = .home

    var body: some View {
        switch session.role {
        case nil:
            RoleSelectView()
        case .kid:
            KiweeGlassTabBar(selectedTab: $selectedTab)
                // Avatar-seeded accent: "KK" = pink → magenta family
                .tint(user.avatarGradientColors.first ?? .pink)
        case .parent:
            ParentProfileView()
        }
    }
}

#Preview {
    ContentView()
        .environment(AppSession())
        .environment(User.sample)
        .environment(ParentUser.sample)
}
