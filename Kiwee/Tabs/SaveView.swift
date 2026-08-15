import SwiftUI

struct SaveView: View {
    @Environment(KiweeTheme.self) private var theme

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(spacing: 8) {
                        Image(systemName: "target")
                            .font(.system(size: 44))
                            .foregroundStyle(theme.personalPrimary)
                        // Heading — Lexend (brand voice)
                        Text("3 Active Goals")
                            .font(.kiwee(.heading3))
                            .foregroundStyle(KiweeColor.textPrimary)
                        // Supporting copy — Inter
                        Text("$87.50 saved so far")
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
                    ForEach(0..<3) { index in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: ["bicycle", "headphones", "teddybear"][index])
                                    .foregroundStyle(theme.personalPrimary)
                                // Goal name — Inter 600 (information layer)
                                Text(["New Bike", "Headphones", "Stuffed Animal"][index])
                                    .font(.inter(size: 16, weight: .semibold))
                                    .foregroundStyle(KiweeColor.textPrimary)
                                Spacer()
                                // Progress ratio — Inter 400 (financial metadata)
                                Text(["$45/$120", "$32/$80", "$10.50/$25"][index])
                                    .font(.kiwee(.transactionMeta))
                                    .foregroundStyle(KiweeColor.textSecondary)
                            }

                            ProgressView(value: [0.375, 0.4, 0.42][index])
                                .tint(theme.progressValue)
                        }
                        .padding(.vertical, 4)
                    }
                } header: {
                    // Section overline — Figtree
                    Text("Savings Goals")
                        .font(.kiwee(.overline))
                }
            }
            .navigationTitle("Save")
        }
    }
}
