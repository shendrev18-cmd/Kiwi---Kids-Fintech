import SwiftUI

struct HomeView: View {
    @Environment(KiweeTheme.self) private var theme

    var body: some View {
        NavigationStack {
            List {
                // Hero balance card
                Section {
                    VStack(spacing: 8) {
                        Text("Your Balance")
                            .font(.kiwee(.financialLabel))
                            .foregroundStyle(KiweeColor.textSecondary)
                        Text("$142.50")
                            .font(.kiwee(.balanceXL))
                            .foregroundStyle(KiweeColor.textPrimary)
                        Text("↑ $12.00 this week")
                            .font(.kiwee(.transactionMeta))
                            .foregroundStyle(KiweeColor.success)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                    .listRowBackground(
                        theme.avatar.softBackgroundGradient
                    )
                }

                // Recent activity
                Section {
                    ForEach(0..<8) { index in
                        HStack {
                            Circle()
                                .fill(KiweeColor.surface3)
                                .frame(width: 40, height: 40)
                                .overlay {
                                    Image(systemName: ["cart", "fork.knife", "tram", "gamecontroller", "book", "gift", "music.note", "star"][index])
                                        .font(.system(size: 16))
                                        .foregroundStyle(index == 7 ? theme.personalPrimary : KiweeColor.textPrimary)
                                }

                            VStack(alignment: .leading, spacing: 2) {
                                // Transaction name — Inter 600 (spec §16 Level 1)
                                Text(["Grocery Store", "Lunch", "Bus Pass", "Game", "Bookshop", "Gift", "Music", "Reward"][index])
                                    .font(.inter(size: 16, weight: .semibold))
                                    .foregroundStyle(KiweeColor.textPrimary)
                                // Date — Inter 400 (spec §16 Level 2)
                                Text("Today")
                                    .font(.kiwee(.transactionMeta))
                                    .foregroundStyle(KiweeColor.textSecondary)
                            }

                            Spacer()

                            // Amount — Inter 600 (spec §16 Level 3)
                            Text(["-$4.50", "-$8.00", "-$2.50", "-$12.99", "-$6.75", "-$15.00", "-$1.99", "+$5.00"][index])
                                .font(.kiwee(.transactionAmount))
                                .foregroundStyle(index == 7 ? KiweeColor.success : KiweeColor.textPrimary)
                        }
                        .padding(.vertical, 4)
                    }
                } header: {
                    // Section overline — Figtree (spec §10)
                    Text("Recent")
                        .font(.kiwee(.overline))
                }
            }
            .navigationTitle("Home")
        }
    }
}
