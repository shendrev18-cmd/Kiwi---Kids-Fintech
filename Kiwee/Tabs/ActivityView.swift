import SwiftUI

struct ActivityView: View {
    @Environment(User.self) private var user

    @State private var activeFilter: ActivityFilter = .all
    @State private var showRunningBalance = false
    @State private var selectedTx: ActivityTransaction? = nil

    enum ActivityFilter: String, CaseIterable {
        case all     = "All"
        case earned  = "Earned"
        case spent   = "Spent"
        case saved   = "Saved"
        case pending = "Pending"
    }

    private var filtered: [ActivityTransaction] {
        let sorted = user.activityTransactions.sorted { $0.date > $1.date }
        switch activeFilter {
        case .all:     return sorted
        case .earned:  return sorted.filter { $0.category == .earned && $0.status == .completed }
        case .spent:   return sorted.filter { $0.category == .spent }
        case .saved:   return sorted.filter { $0.category == .saved }
        case .pending: return sorted.filter { $0.status == .pending }
        }
    }

    /// Transactions grouped by calendar day, newest-first.
    private var grouped: [(key: Date, txns: [ActivityTransaction])] {
        let cal = Calendar.current
        var dict: [Date: [ActivityTransaction]] = [:]
        for tx in filtered {
            let day = cal.startOfDay(for: tx.date)
            dict[day, default: []].append(tx)
        }
        return dict.sorted { $0.key > $1.key }.map { (key: $0.key, txns: $0.value) }
    }

    var body: some View {
        NavigationStack {
            List {
                // ── Filter chips ───────────────────────────────────────────
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(ActivityFilter.allCases, id: \.rawValue) { f in
                                ActivityFilterChip(label: f.rawValue, isSelected: activeFilter == f) {
                                    activeFilter = f
                                }
                            }
                        }
                        .padding(.horizontal, 2)
                    }
                    .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }

                // ── Transactions grouped by date ───────────────────────────
                if grouped.isEmpty {
                    Section {
                        ContentUnavailableView(
                            "No transactions",
                            systemImage: "arrow.left.arrow.right",
                            description: Text("Transactions will appear here once money moves.")
                        )
                        .listRowBackground(Color.clear)
                    }
                } else {
                    ForEach(grouped, id: \.key) { group in
                        Section(header: DateHeader(date: group.key)) {
                            ForEach(group.txns) { tx in
                                ActivityRow(tx: tx, showRunningBalance: showRunningBalance)
                                    .contentShape(Rectangle())
                                    .onTapGesture { selectedTx = tx }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Activity")
            .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 80) }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showRunningBalance.toggle()
                    } label: {
                        Image(systemName: showRunningBalance ? "chart.line.uptrend.xyaxis.circle.fill" : "chart.line.uptrend.xyaxis.circle")
                    }
                }
            }
            .sheet(item: $selectedTx) { tx in
                TransactionDetailView(tx: tx)
            }
        }
    }
}

// MARK: - DateHeader

private struct DateHeader: View {
    let date: Date

    var body: some View {
        let cal = Calendar.current
        let today     = cal.startOfDay(for: .now)
        let yesterday = cal.date(byAdding: .day, value: -1, to: today)!

        Group {
            if cal.isDate(date, inSameDayAs: today) {
                Text("Today")
            } else if cal.isDate(date, inSameDayAs: yesterday) {
                Text("Yesterday")
            } else {
                Text(date.formatted(.dateTime.weekday(.wide).month().day()))
            }
        }
        .font(.caption.weight(.semibold))
        .foregroundStyle(.secondary)
        .textCase(nil)
    }
}

// MARK: - ActivityRow

private struct ActivityRow: View {
    let tx: ActivityTransaction
    let showRunningBalance: Bool

    var body: some View {
        HStack(spacing: 12) {
            // Category icon — distinct per type
            Image(systemName: tx.category.icon)
                .font(.body)
                .foregroundStyle(tx.category.color)
                .frame(width: 38, height: 38)
                .background(tx.category.color.opacity(0.12), in: Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(tx.title)
                    .font(.subheadline.weight(.medium))
                    .italic(tx.status == .pending)
                    .foregroundStyle(tx.status == .pending ? .secondary : .primary)

                // Reason line — never empty
                Text(tx.contextLine)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                if tx.status == .pending {
                    Text(tx.amount, format: .currency(code: "USD").sign(strategy: .always()))
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .italic()
                } else {
                    Text(tx.amount, format: .currency(code: "USD").sign(strategy: .always()))
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(tx.amount >= 0 ? .green : .primary)
                }

                if showRunningBalance {
                    Text(tx.balanceAfter, format: .currency(code: "USD"))
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
            }
        }
        .padding(.vertical, 3)
    }
}

// MARK: - ActivityFilterChip

private struct ActivityFilterChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.subheadline.weight(isSelected ? .semibold : .regular))
                .padding(.horizontal, 14).padding(.vertical, 7)
                .background(isSelected ? Color.accentColor : Color.secondary.opacity(0.1), in: Capsule())
                .foregroundStyle(isSelected ? .white : .secondary)
        }
        .buttonStyle(.plain)
        .animation(.spring(duration: 0.2), value: isSelected)
    }
}

// MARK: - Preview

#Preview {
    ActivityView()
        .environment(User.sample)
}
