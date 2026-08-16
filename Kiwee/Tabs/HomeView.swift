import SwiftUI

struct HomeView: View {
    @Environment(User.self) private var user
    @Binding var selectedTab: KiweeTab

    @State private var balanceMode: BalanceMode = .spending

    enum BalanceMode { case spending, saving }

    private var displayBalance: Double {
        balanceMode == .spending ? user.balance : user.savingsBalance
    }

    private var pendingChores: [Chore] {
        user.chores.filter { $0.status == .toDo }
    }

    private var topGoal: SavingsGoal? {
        user.savingsGoals.first(where: { !$0.isCompleted })
    }

    var body: some View {
        NavigationStack {
            List {
                // ── Hero (full-bleed, no insets) ──────────────────────────
                Section {
                    heroCard
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                }

                // ── Quick actions ──────────────────────────────────────────
                Section {
                    quickActions
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                }

                // ── Recent activity ────────────────────────────────────────
                Section("Recent") {
                    ForEach(user.activityTransactions.prefix(5)) { tx in
                        RecentActivityRow(tx: tx)
                    }
                    Button {
                        selectedTab = .activity
                    } label: {
                        Text("See all activity")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
            // Fix: add bottom padding so rows aren't clipped behind the tab bar
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 80)
            }
        }
    }

    // MARK: - Hero card

    private var heroCard: some View {
        VStack(spacing: 20) {
            // Row 1: avatar · segmented · XP badge · bell
            HStack(spacing: 10) {
                // Avatar — initials on gradient, never a placeholder glyph
                Circle()
                    .fill(LinearGradient(
                        colors: user.avatarGradientColors,
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ))
                    .frame(width: 36, height: 36)
                    .overlay {
                        Text(user.avatarInitials.isEmpty ? "?" : user.avatarInitials)
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                    }

                Picker("Balance mode", selection: $balanceMode) {
                    Text("Spending").tag(BalanceMode.spending)
                    Text("Saving").tag(BalanceMode.saving)
                }
                .pickerStyle(.segmented)
                .colorMultiply(.white)

                Spacer()

                // XP badge
                HStack(spacing: 3) {
                    Text("G")
                        .font(.caption2.weight(.heavy))
                    Text("\(user.xp)")
                        .font(.caption.weight(.semibold))
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.green.opacity(0.25), in: Capsule())
                .foregroundStyle(.green)

                // Bell
                Button { } label: {
                    Image(systemName: "bell")
                        .foregroundStyle(.white.opacity(0.75))
                }
            }

            // Row 2: balance label + amount
            VStack(spacing: 4) {
                Text(balanceMode == .spending ? "Card balance, USD" : "Savings balance, USD")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.55))

                Text(displayBalance, format: .currency(code: "USD"))
                    .font(.system(size: 46, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .contentTransition(.numericText(value: displayBalance))
                    .animation(.spring(duration: 0.35), value: balanceMode)
            }

            // Row 3: single state-driven CTA
            ctaButton

            // Row 4: goal ticker (muted, tap → Save tab)
            if let goal = topGoal {
                Button { selectedTab = .save } label: {
                    HStack(spacing: 6) {
                        Text(goal.emoji)
                        Text("\(goal.name) · \(goal.currentAmount, format: .currency(code: "USD")) of \(goal.targetAmount, format: .currency(code: "USD")) · ~\(weeksRemaining(goal))w to go")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.50))
                            .lineLimit(1)
                    }
                }
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [Color(red: 0.1, green: 0.55, blue: 0.25), .black.opacity(0.92)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }

    // MARK: - CTA — exactly one, chosen by state

    @ViewBuilder
    private var ctaButton: some View {
        let pending = pendingChores

        if user.balance == 0 {
            HeroCTAButton(
                label: "Request Money",
                icon: "arrow.down.circle",
                color: .green
            ) {
                // TODO: Request money flow
            }
        } else if !pending.isEmpty {
            HeroCTAButton(
                label: "\(pending.count) chore\(pending.count == 1 ? "" : "s") waiting",
                icon: "list.bullet.clipboard",
                color: .orange
            ) {
                selectedTab = .earn
            }
        } else {
            HeroCTAButton(
                label: "Move to a goal",
                icon: "target",
                color: .teal
            ) {
                selectedTab = .save
            }
        }
    }

    // MARK: - Quick actions

    private var quickActions: some View {
        HStack(spacing: 0) {
            let canSelfFund = user.balance > 0
            QuickActionButton(
                icon:  canSelfFund ? "plus.circle.fill" : "arrow.down.circle.fill",
                label: canSelfFund ? "Add Money" : "Request",
                color: .green
            ) { }
            QuickActionButton(icon: "arrow.up.right.circle.fill", label: "Send",  color: .blue)   { }
            QuickActionButton(icon: "target",                      label: "Goals", color: .purple) { selectedTab = .save }
            QuickActionButton(icon: "list.bullet.clipboard.fill",  label: "Earn",  color: .orange) { selectedTab = .earn }
        }
        .padding(.vertical, 8)
    }

    // MARK: - Helpers

    private func weeksRemaining(_ goal: SavingsGoal) -> Int {
        let remaining = goal.targetAmount - goal.currentAmount
        guard remaining > 0 else { return 0 }
        let weeklyRate = max(5.0, Double(user.chores.filter { $0.status == .approved }.count) * 1.5 + 5.0)
        return max(1, Int(ceil(remaining / weeklyRate)))
    }
}

// MARK: - HeroCTAButton

private struct HeroCTAButton: View {
    let label: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(label, systemImage: icon)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(color.opacity(0.28), in: RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(color.opacity(0.5), lineWidth: 1))
        }
    }
}

// MARK: - QuickActionButton

private struct QuickActionButton: View {
    let icon: String
    let label: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(color)
                Text(label)
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
        }
    }
}

// MARK: - RecentActivityRow

private struct RecentActivityRow: View {
    let tx: ActivityTransaction

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: tx.category.icon)
                .font(.body)
                .foregroundStyle(tx.category.color)
                .frame(width: 36, height: 36)
                .background(tx.category.color.opacity(0.12), in: Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(tx.title)
                    .font(.subheadline.weight(.medium))
                Text(tx.contextLine)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            Text(tx.amount, format: .currency(code: "USD").sign(strategy: .always()))
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(tx.amount >= 0 ? .green : .primary)
        }
        .padding(.vertical, 2)
    }
}

// MARK: - Preview

#Preview {
    HomeView(selectedTab: .constant(.home))
        .environment(User.sample)
}
