import SwiftUI

struct GoalDetailView: View {
    @Environment(User.self) private var user
    let goalID: UUID

    @State private var showMoveIn    = false
    @State private var showDeleteConfirm = false
    @Environment(\.dismiss) private var dismiss

    private var goal: SavingsGoal? {
        user.savingsGoals.first { $0.id == goalID }
    }

    var body: some View {
        Group {
            if let goal {
                content(goal: goal)
            } else {
                ContentUnavailableView("Goal not found", systemImage: "target")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func content(goal: SavingsGoal) -> some View {
        List {
            // ── Ring + progress ───────────────────────────────────────────
            Section {
                VStack(spacing: 20) {
                    // Progress ring
                    ZStack {
                        Circle()
                            .stroke(Color.secondary.opacity(0.15), lineWidth: 14)
                        Circle()
                            .trim(from: 0, to: goal.progress)
                            .stroke(
                                LinearGradient(colors: [.purple, .indigo],
                                               startPoint: .topLeading, endPoint: .bottomTrailing),
                                style: StrokeStyle(lineWidth: 14, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))
                        VStack(spacing: 4) {
                            Text(goal.emoji).font(.system(size: 32))
                            Text("\(Int(goal.progress * 100))%")
                                .font(.title.bold())
                        }
                    }
                    .frame(width: 150, height: 150)

                    VStack(spacing: 4) {
                        Text(goal.name).font(.title3.bold())
                        Text("\(goal.currentAmount, format: .currency(code: "USD")) of \(goal.targetAmount, format: .currency(code: "USD"))")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        if let projected = projectedDate(goal) {
                            Text("On track for \(projected.formatted(.dateTime.month().year()))")
                                .font(.caption)
                                .foregroundStyle(.purple)
                        }
                    }

                    // Actions
                    HStack(spacing: 12) {
                        Button {
                            showMoveIn = true
                        } label: {
                            Label("Move Money In", systemImage: "arrow.down.circle.fill")
                                .font(.subheadline.weight(.semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(.purple.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                        .disabled(user.balance <= 0)

                        Button {
                            // Move money out requires parent approval
                        } label: {
                            Label("Move Out", systemImage: "arrow.up.circle")
                                .font(.subheadline.weight(.semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(.secondary.opacity(0.08), in: RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(.secondary)
                        .help("Requires parent approval")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .listRowBackground(Color.clear)
            }

            // ── Contribution history ──────────────────────────────────────
            if !goal.history.isEmpty {
                Section("History") {
                    ForEach(goal.history) { contribution in
                        HStack {
                            Image(systemName: contribution.amount >= 0 ? "arrow.down.circle.fill" : "arrow.up.circle.fill")
                                .foregroundStyle(contribution.amount >= 0 ? .green : .red)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(contribution.note.isEmpty ? "Transfer" : contribution.note)
                                    .font(.subheadline)
                                Text(contribution.date.formatted(.dateTime.month().day().year()))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(contribution.amount, format: .currency(code: "USD").sign(strategy: .always()))
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(contribution.amount >= 0 ? .green : .red)
                        }
                    }
                }
            }

            // ── Edit / Delete ─────────────────────────────────────────────
            Section {
                Button(role: .destructive) {
                    showDeleteConfirm = true
                } label: {
                    Label("Delete Goal", systemImage: "trash")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .navigationTitle(goal.name)
        .confirmationDialog("Delete \"\(goal.name)\"?",
                            isPresented: $showDeleteConfirm, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                user.savingsGoals.removeAll { $0.id == goalID }
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Money saved will be returned to your spending balance.")
        }
        .sheet(isPresented: $showMoveIn) {
            MoveMoneyInView(goalID: goalID)
        }
    }

    private func projectedDate(_ goal: SavingsGoal) -> Date? {
        let remaining = goal.targetAmount - goal.currentAmount
        guard remaining > 0, user.autoSavePercentage > 0 else { return nil }
        // Estimate weekly contribution from auto-save on typical chore income
        let weeklyContribution = max(1.0, 15.0 * user.autoSavePercentage / 100.0)
        let weeksNeeded = Int(ceil(remaining / weeklyContribution))
        return Calendar.current.date(byAdding: .weekOfYear, value: weeksNeeded, to: .now)
    }
}

// MARK: - MoveMoneyInView

private struct MoveMoneyInView: View {
    @Environment(User.self) private var user
    @Environment(\.dismiss) private var dismiss
    let goalID: UUID

    @State private var amountText = ""

    private var amount: Double { Double(amountText) ?? 0 }
    private var canMove: Bool   { amount > 0 && amount <= user.balance }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Text("Available")
                        Spacer()
                        Text(user.balance, format: .currency(code: "USD"))
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Amount to Move") {
                    TextField("0.00", text: $amountText)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Move Money In")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading)  { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Move") {
                        if let i = user.savingsGoals.firstIndex(where: { $0.id == goalID }) {
                            user.savingsGoals[i].currentAmount += amount
                            user.savingsGoals[i].history.append(
                                GoalContribution(id: UUID(), date: .now, amount: amount, note: "Moved in")
                            )
                            if user.savingsGoals[i].currentAmount >= user.savingsGoals[i].targetAmount {
                                user.savingsGoals[i].isCompleted = true
                            }
                        }
                        user.balance -= amount
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(!canMove)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        GoalDetailView(goalID: User.sample.savingsGoals[0].id)
            .environment(User.sample)
    }
}
