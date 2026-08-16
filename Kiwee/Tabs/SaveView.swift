import SwiftUI

struct SaveView: View {
    @Environment(User.self) private var user

    @State private var showNewGoal = false

    private var activeGoals: [SavingsGoal]    { user.savingsGoals.filter { !$0.isCompleted } }
    private var completedGoals: [SavingsGoal] { user.savingsGoals.filter {  $0.isCompleted } }

    var body: some View {
        NavigationStack {
            List {
                // ── Summary banner ─────────────────────────────────────────
                Section {
                    VStack(spacing: 6) {
                        Image(systemName: "target")
                            .font(.system(size: 36))
                            .foregroundStyle(.purple)
                        Text("\(activeGoals.count) Active \(activeGoals.count == 1 ? "Goal" : "Goals")")
                            .font(.headline)
                        Text(user.savingsBalance, format: .currency(code: "USD"))
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                        Text("saved so far")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .listRowBackground(
                        LinearGradient(
                            colors: [.purple.opacity(0.18), .indigo.opacity(0.12)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )
                }

                // ── Auto-save rule ─────────────────────────────────────────
                autoSaveSection

                // ── Active goals or empty state ────────────────────────────
                if activeGoals.isEmpty {
                    Section {
                        emptyState
                            .listRowBackground(Color.clear)
                    }
                } else {
                    Section("Savings Goals") {
                        ForEach(activeGoals) { goal in
                            NavigationLink { GoalDetailView(goalID: goal.id) } label: {
                                GoalRow(goal: goal)
                            }
                        }
                    }
                }

                // ── Completed goals ────────────────────────────────────────
                if !completedGoals.isEmpty {
                    Section("Completed 🎉") {
                        ForEach(completedGoals) { goal in
                            HStack(spacing: 12) {
                                Text(goal.emoji)
                                    .font(.title2)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(goal.name)
                                        .font(.subheadline.weight(.medium))
                                        .strikethrough(color: .secondary)
                                    Text(goal.targetAmount, format: .currency(code: "USD"))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Image(systemName: "trophy.fill")
                                    .foregroundStyle(.yellow)
                            }
                            .padding(.vertical, 2)
                        }
                    }
                }

                // ── New goal CTA ───────────────────────────────────────────
                Section {
                    Button {
                        showNewGoal = true
                    } label: {
                        Label("New Goal", systemImage: "plus.circle.fill")
                    }
                }
            }
            .navigationTitle("Save")
            .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 80) }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showNewGoal = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showNewGoal) {
                NewGoalView()
            }
        }
    }

    // MARK: - Auto-save slider

    private var autoSaveSection: some View {
        @Bindable var user = user

        return Section {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Label("Auto-Save", systemImage: "arrow.clockwise")
                        .font(.subheadline.weight(.medium))
                    Spacer()
                    Text("\(Int(user.autoSavePercentage))% of earnings")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Slider(value: $user.autoSavePercentage, in: 0...50, step: 5)
                    .tint(.purple)
            }
            .padding(.vertical, 4)
        } header: {
            Text("Round-Up Rule")
        } footer: {
            if user.autoSavePercentage > 0 {
                Text("Automatically move \(Int(user.autoSavePercentage))% of every chore payment into your top goal.")
            } else {
                Text("Set a percentage to automatically save a slice of every chore payment.")
            }
        }
    }

    // MARK: - Empty state with quick-start chips

    private var emptyState: some View {
        VStack(spacing: 20) {
            Text("🎯")
                .font(.system(size: 48))
            Text("No goals yet")
                .font(.headline)
            Text("What are you saving for?")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            // Quick-start chips
            HStack(spacing: 10) {
                ForEach([("🚲", "Bike"), ("🎮", "Game"), ("👟", "Sneakers")], id: \.0) { pair in
                    Button {
                        // pre-fill and open new goal sheet
                        showNewGoal = true
                    } label: {
                        VStack(spacing: 4) {
                            Text(pair.0).font(.title2)
                            Text(pair.1).font(.caption2)
                        }
                        .padding(.horizontal, 14).padding(.vertical, 10)
                        .background(.purple.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }
                Button {
                    showNewGoal = true
                } label: {
                    VStack(spacing: 4) {
                        Text("✏️").font(.title2)
                        Text("Custom").font(.caption2)
                    }
                    .padding(.horizontal, 14).padding(.vertical, 10)
                    .background(.purple.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
    }
}

// MARK: - GoalRow

private struct GoalRow: View {
    let goal: SavingsGoal

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(goal.emoji)
                    .font(.title2)
                Text(goal.name)
                    .font(.subheadline.weight(.medium))
                Spacer()
                Text("\(goal.currentAmount, format: .currency(code: "USD")) / \(goal.targetAmount, format: .currency(code: "USD"))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: goal.progress)
                .tint(.purple)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - NewGoalView

struct NewGoalView: View {
    @Environment(User.self) private var user
    @Environment(\.dismiss) private var dismiss

    @State private var name         = ""
    @State private var emoji        = "🎯"
    @State private var targetAmount = 50.0

    private let quickStart: [(emoji: String, name: String, amount: Double)] = [
        ("🚲", "Bike",     120), ("🎮", "Game",     60),
        ("👟", "Sneakers",  80), ("🎯", "Custom",   50),
    ]

    var body: some View {
        NavigationStack {
            List {
                // Quick-start chips
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(quickStart, id: \.name) { opt in
                                Button {
                                    emoji        = opt.emoji
                                    if opt.name != "Custom" { name = opt.name }
                                    targetAmount = opt.amount
                                } label: {
                                    VStack(spacing: 4) {
                                        Text(opt.emoji).font(.title2)
                                        Text(opt.name).font(.caption2)
                                    }
                                    .padding(.horizontal, 14).padding(.vertical, 10)
                                    .background(name == opt.name ? Color.purple.opacity(0.2) : Color.secondary.opacity(0.1),
                                                in: RoundedRectangle(cornerRadius: 12))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 2)
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .listRowBackground(Color.clear)
                }

                Section("Name") {
                    HStack(spacing: 10) {
                        TextField("🎯", text: $emoji)
                            .font(.title2)
                            .frame(width: 40)
                        TextField("Goal name", text: $name)
                            .autocorrectionDisabled()
                    }
                }

                Section("Target Amount") {
                    Stepper(value: $targetAmount, in: 5...1000, step: 5) {
                        Text(targetAmount, format: .currency(code: "USD"))
                    }
                }
            }
            .navigationTitle("New Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Create") {
                        user.savingsGoals.append(SavingsGoal(
                            id: UUID(), name: name, emoji: emoji,
                            currentAmount: 0, targetAmount: targetAmount,
                            createdDate: .now, isCompleted: false, history: []
                        ))
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    SaveView()
        .environment(User.sample)
}
