import SwiftUI

// MARK: - TransactionRow

/// A single row displaying one transaction: category icon, merchant name,
/// relative timestamp, and signed amount.
struct TransactionRow: View {
    let transaction: Transaction

    var body: some View {
        HStack(spacing: 12) {
            // Category icon badge
            Image(systemName: transaction.category.symbol)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(transaction.category.color)
                .frame(width: 44, height: 44)
                .background(
                    transaction.category.color.opacity(0.14),
                    in: RoundedRectangle(cornerRadius: KiweeTheme.Radius.icon)
                )

            // Merchant + relative date
            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.merchant)
                    .font(.subheadline.weight(.medium))

                Text(transaction.date, style: .relative)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            // Signed amount
            let sign = transaction.isIncoming ? "+" : "-"
            Text("\(sign)\(transaction.amount.formatted(.currency(code: "USD")))")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(transaction.isIncoming ? Color.kiweeGreen : Color.primary)
        }
        .padding(.vertical, 6)
        .accessibilityElement(children: .combine)
    }
}
