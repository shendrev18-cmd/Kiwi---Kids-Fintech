import SwiftUI

struct TransactionHistoryView: View {
    @Environment(ParentUser.self) private var parent

    @State private var selectedChild: String = "All"

    private var childNames: [String] {
        ["All"] + parent.children.map(\.name)
    }

    private var filteredTransactions: [FamilyTransaction] {
        let sorted = parent.transactions.sorted { $0.date > $1.date }
        guard selectedChild != "All" else { return sorted }
        return sorted.filter { $0.childName == selectedChild }
    }

    /// CSV representation of the filtered transaction list.
    private var csvExport: String {
        let header = "Date,Child,Description,Amount,Type\n"
        let rows = filteredTransactions.map { t in
            "\(t.date.formatted(.dateTime.month().day().year())),\(t.childName),\(t.description),\(String(format: "%.2f", t.amount)),\(t.type.label)\n"
        }
        return header + rows.joined()
    }

    var body: some View {
        List {
            // Filter
            Section {
                Picker("Filter by child", selection: $selectedChild) {
                    ForEach(childNames, id: \.self) { name in
                        Text(name).tag(name)
                    }
                }
                .pickerStyle(.segmented)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
            }

            // Transactions
            if filteredTransactions.isEmpty {
                Section {
                    ContentUnavailableView(
                        "No transactions",
                        systemImage: "list.bullet.rectangle",
                        description: Text("Transactions will appear here once money moves.")
                    )
                }
            } else {
                Section {
                    ForEach(filteredTransactions) { transaction in
                        TransactionRow(transaction: transaction)
                    }
                }
            }
        }
        .navigationTitle("Transaction History")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ShareLink(
                    item: csvExport,
                    subject: Text("Kiwee Transactions"),
                    message: Text("Family transaction history from Kiwee.")
                ) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }
}

// MARK: - TransactionRow

private struct TransactionRow: View {
    let transaction: FamilyTransaction

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: transaction.type.icon)
                .font(.body)
                .foregroundStyle(transaction.type.color)
                .frame(width: 32, height: 32)
                .background(transaction.type.color.opacity(0.12), in: Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.description)
                    .font(.subheadline.weight(.medium))
                HStack(spacing: 4) {
                    Text(transaction.childName)
                    Text("·")
                        .foregroundStyle(.tertiary)
                    Text(transaction.date.formatted(.dateTime.month().day()))
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            Spacer()

            Text(transaction.amount, format: .currency(code: "USD").sign(strategy: .always()))
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(transaction.amount >= 0 ? .green : .red)
        }
        .padding(.vertical, 2)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        TransactionHistoryView()
            .environment(ParentUser.sample)
    }
}
