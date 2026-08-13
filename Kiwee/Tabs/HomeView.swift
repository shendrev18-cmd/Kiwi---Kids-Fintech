import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            List {
                // Hero balance card
                Section {
                    VStack(spacing: 8) {
                        Text("Your Balance")
                            .font(.figtree(.subheadline))
                            .foregroundStyle(.secondary)
                        Text("$142.50")
                            .font(.lexend(size: 40, weight: .bold))
                        Text("↑ $12.00 this week")
                            .font(.figtree(.caption))
                            .foregroundStyle(.green)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                    .listRowBackground(
                        LinearGradient(
                            colors: [.green.opacity(0.3), .mint.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                }

                // Recent activity
                Section("Recent") {
                    ForEach(0..<8) { index in
                        HStack {
                            Circle()
                                .fill(Color(hue: Double(index) / 8.0, saturation: 0.5, brightness: 0.9))
                                .frame(width: 40, height: 40)
                                .overlay {
                                    Image(systemName: ["cart", "fork.knife", "tram", "gamecontroller", "book", "gift", "music.note", "star"][index])
                                        .font(.system(size: 16))
                                        .foregroundStyle(.white)
                                }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(["Grocery Store", "Lunch", "Bus Pass", "Game", "Bookshop", "Gift", "Music", "Reward"][index])
                                    .font(.figtree(.subheadline, weight: .medium))
                                Text("Today")
                                    .font(.figtree(.caption))
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Text(["-$4.50", "-$8.00", "-$2.50", "-$12.99", "-$6.75", "-$15.00", "-$1.99", "+$5.00"][index])
                                .font(.figtree(.subheadline, weight: .semibold))
                                .foregroundStyle(index == 7 ? .green : .primary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Home")
        }
    }
}
