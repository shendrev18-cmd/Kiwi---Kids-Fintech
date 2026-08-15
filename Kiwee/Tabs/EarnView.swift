import SwiftUI

struct EarnView: View {
    @Environment(KiweeTheme.self) private var theme

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(spacing: 8) {
                        Image(systemName: "piggybank.fill")
                            .font(.system(size: 44))
                            .foregroundStyle(theme.personalPrimary)
                        // Heading — Lexend (spec §4: major financial summary)
                        Text("$32.00 earned this month")
                            .font(.kiwee(.heading3))
                            .foregroundStyle(KiweeColor.textPrimary)
                        // Supporting copy — Inter (spec §6)
                        Text("Keep it up!")
                            .font(.kiwee(.bodySmall))
                            .foregroundStyle(KiweeColor.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .listRowBackground(
                        theme.avatar.softBackgroundGradient
                    )
                }

                Section {
                    ForEach(0..<6) { index in
                        HStack {
                            Image(systemName: ["trash", "leaf", "cup.and.saucer", "dog", "bed.double", "book"][index])
                                .font(.title3)
                                .foregroundStyle(theme.personalPrimary)
                                .frame(width: 36)

                            VStack(alignment: .leading, spacing: 2) {
                                // Chore name — Inter 600 (information layer)
                                Text(["Take Out Trash", "Mow Lawn", "Wash Dishes", "Walk the Dog", "Make Bed", "Read 30 min"][index])
                                    .font(.inter(size: 16, weight: .semibold))
                                    .foregroundStyle(KiweeColor.textPrimary)
                                // Frequency — Inter 400 (metadata)
                                Text(["Daily", "Weekly", "Daily", "Daily", "Daily", "Daily"][index])
                                    .font(.kiwee(.transactionMeta))
                                    .foregroundStyle(KiweeColor.textSecondary)
                            }

                            Spacer()

                            // Reward amount — Inter 600 (financial)
                            Text(["$1.00", "$5.00", "$2.00", "$3.00", "$0.50", "$1.50"][index])
                                .font(.kiwee(.transactionAmount))
                                .foregroundStyle(theme.personalPrimary)
                        }
                        .padding(.vertical, 4)
                    }
                } header: {
                    // Section overline — Figtree
                    Text("Available Chores")
                        .font(.kiwee(.overline))
                }
            }
            .navigationTitle("Earn")
        }
    }
}
