import SwiftUI

// MARK: - HomeHeaderView

/// Slim top bar above the hero: greeting on the left,
/// notification bell on the right.
struct HomeHeaderView: View {
    let user: User

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            // Greeting + first name
            VStack(alignment: .leading, spacing: 2) {
                Text(greeting)
                    .font(.figtree(.subheadline, weight: .regular))
                    .foregroundStyle(.secondary)
                Text(user.firstName)
                    .font(.lexend(.title2, weight: .bold))
            }

            Spacer()

            // Notification bell
            Button {
                // TODO: navigate to notifications
            } label: {
                Image(systemName: "bell.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.primary)
                    .frame(width: 40, height: 40)
                    .background(.regularMaterial, in: Circle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Notifications")
        }
    }

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: .now)
        switch hour {
        case 0..<12: return "Good morning,"
        case 12..<17: return "Good afternoon,"
        default:     return "Good evening,"
        }
    }
}
