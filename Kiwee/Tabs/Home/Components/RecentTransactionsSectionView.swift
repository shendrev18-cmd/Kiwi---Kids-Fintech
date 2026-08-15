import SwiftUI

// MARK: - RecentTransactionsSectionView

/// Displays recent transactions grouped inside a single material card —
/// the "grouped card" pattern used by premium fintech apps.
struct RecentTransactionsSectionView: View {
    let transactions: [Transaction]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(
                title: "Recent",
                systemImage: "clock.fill",
                action: { /* navigate to ActivityView */ }
            )

            VStack(spacing: 0) {
                ForEach(Array(transactions.enumerated()), id: \.element.id) { index, tx in
                    TransactionRow(transaction: tx)
                        .padding(.horizontal, 14)

                    if index < transactions.count - 1 {
                        Divider()
                            .padding(.leading, 70) // aligns with text, not icon
                    }
                }
            }
            .background(
                Color(.secondarySystemGroupedBackground),
                in: RoundedRectangle(cornerRadius: KiweeTheme.Radius.card)
            )
        }
    }
}
