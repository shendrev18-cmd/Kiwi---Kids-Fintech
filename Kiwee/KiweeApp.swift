import SwiftUI

@main
struct KiweeApp: App {
    @State private var session    = AppSession()
    @State private var user       = User.sample
    @State private var parentUser = ParentUser.sample

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(session)
                .environment(user)
                .environment(parentUser)
        }
    }
}
