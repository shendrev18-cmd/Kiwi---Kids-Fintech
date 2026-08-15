import SwiftUI

/// The root app shell.
///
/// Routes to `RoleSelectView`, the kid tab bar, or the parent profile
/// based on the current `AppSession` role.  Setting `session.role = nil`
/// from anywhere in the hierarchy returns the user to role select.
struct ContentView: View {
    @Environment(AppSession.self) private var session
    @State private var selectedTab: KiweeTab = .home

    var body: some View {
        switch session.role {
        case nil:
            RoleSelectView()
        case .kid:
            KiweeGlassTabBar(selectedTab: $selectedTab)
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
