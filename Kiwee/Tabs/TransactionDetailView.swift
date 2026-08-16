import SwiftUI

struct TransactionDetailView: View {
    let tx: ActivityTransaction
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                // ── Amount + status ────────────────────────────────────────
                Section {
                    VStack(spacing: 12) {
                        Image(systemName: tx.category.icon)
                            .font(.system(size: 40))
                            .foregroundStyle(tx.category.color)
                            .padding(16)
                            .background(tx.category.color.opacity(0.12), in: Circle())

                        Text(tx.amount, format: .currency(code: "USD").sign(strategy: .always()))
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundStyle(tx.amount >= 0 ? .green : .primary)

                        Text(tx.title)
                            .font(.headline)

                        StatusBadge(status: tx.status)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .listRowBackground(Color.clear)
                }

                // ── Details ────────────────────────────────────────────────
                Section("Details") {
                    detailRow(label: "Date & Time",
                              value: tx.date.formatted(.dateTime.weekday(.wide).month().day().year().hour().minute()))

                    detailRow(label: "Reason",   value: tx.contextLine)
                    detailRow(label: "Category", value: tx.category.label)

                    HStack {
                        Text("Balance")
                            .foregroundStyle(.secondary)
                        Spacer()
                        HStack(spacing: 4) {
                            Text(tx.balanceBefore, format: .currency(code: "USD"))
                                .foregroundStyle(.secondary)
                            Image(systemName: "arrow.right")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                            Text(tx.balanceAfter, format: .currency(code: "USD"))
                                .foregroundStyle(tx.amount >= 0 ? .green : .primary)
                        }
                        .font(.subheadline)
                    }
                }

                // ── Photo proof ────────────────────────────────────────────
                if tx.hasPhotoProof {
                    Section("Proof") {
                        HStack(spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                            Text("Photo submitted")
                                .font(.subheadline)
                        }
                    }
                }

                // ── Note ──────────────────────────────────────────────────
                if !tx.note.isEmpty {
                    Section("Note") {
                        Text(tx.note)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
        }
    }

    private func detailRow(label: String, value: String) -> some View {
        HStack {
            Text(label).foregroundStyle(.secondary)
            Spacer()
            Text(value).multilineTextAlignment(.trailing)
        }
        .font(.subheadline)
    }
}

// MARK: - StatusBadge

private struct StatusBadge: View {
    let status: TransactionStatus

    var body: some View {
        switch status {
        case .completed:
            Label("Completed", systemImage: "checkmark.circle.fill")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.green)
                .padding(.horizontal, 10).padding(.vertical, 4)
                .background(.green.opacity(0.1), in: Capsule())
        case .pending:
            Label("Pending", systemImage: "clock.fill")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.orange)
                .padding(.horizontal, 10).padding(.vertical, 4)
                .background(.orange.opacity(0.1), in: Capsule())
        }
    }
}

// MARK: - Preview

#Preview {
    TransactionDetailView(tx: User.sample.activityTransactions[0])
}
