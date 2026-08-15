import SwiftUI

// MARK: - HomeHeaderView

/// Slim top bar above the hero: greeting on the left,
/// dark/light toggle and notification bell on the right.
/// The avatar has moved inside BalanceHeroCard to match the reference design.
struct HomeHeaderView: View {
    let user: User
    @Binding var isDarkMode: Bool

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            // Greeting + first name
            VStack(alignment: .leading, spacing: 2) {
                Text(greeting)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(user.firstName)
                    .font(.title2.bold())
            }

            Spacer()

            // Dark / light mode toggle
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isDarkMode.toggle()
                }
            } label: {
                Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(isDarkMode ? .yellow : .indigo)
                    .frame(width: 40, height: 40)
                    .background(.regularMaterial, in: Circle())
                    .contentTransition(.symbolEffect(.replace))
            }
            .buttonStyle(.plain)
            .accessibilityLabel(isDarkMode ? "Switch to light mode" : "Switch to dark mode")

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
