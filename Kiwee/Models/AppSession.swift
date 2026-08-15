import Foundation

// MARK: - AppRole

enum AppRole: Sendable {
    case kid
    case parent
}

// MARK: - AppSession

/// Drives the top-level navigation gate (role select → kid app / parent profile).
/// Setting `role = nil` returns the user to the role selector.
@Observable
@MainActor
final class AppSession {
    var role: AppRole? = nil

    func signOut() {
        role = nil
    }
}
