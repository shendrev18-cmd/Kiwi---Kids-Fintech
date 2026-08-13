import SwiftUI

@main
struct KiweeApp: App {
    @State private var user = User.sample

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(user)
        }
    }
}
