import SwiftUI

struct EarnView: View {
    @Environment(User.self) private var user

    @State private var filter: ChoreFilter = .today
    @State private var showSuggestChore = false

    enum ChoreFilter: String, CaseIterable {
        case today   = "Today"
        case week    = "This Week"
        case oneTime = "One-time"
        case done    = "Done"
    }

    private var filteredChores: [Chore] {
        switch filter {
        case .today:   return user.chores.filter { $0.status == .toDo || $0.status == .needsRedo }
        case .week:    return user.chores.filter { $0.status != .approved }
        case .oneTime: return user.chores.filter { $0.suggestedByKid }
        case .done:    return user.chores.filter { $0.status == .approved }
        }
    }

    var body: some View {
        NavigationStack {
            List {
                // ── Month-earned banner ────────────────────────────────────
                Section {
                    VStack(spacing: 6) {
                        Image(systemName: "piggybank.fill")
                            .font(.system(size: 36))
                            .foregroundStyle(.orange)
                        Text(user.monthlyEarned, format: .currency(code: "USD"))
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                        Text("earned this month")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .listRowBackground(
                        LinearGradient(
                            colors: [.orange.opacity(0.2), .yellow.opacity(0.12)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )
                }

                // ── Streak strip ───────────────────────────────────────────
                Section {
                    streakStrip
                }

                // ── Filter chips ───────────────────────────────────────────
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(ChoreFilter.allCases, id: \.rawValue) { f in
                                FilterChip(label: f.rawValue, isSelected: filter == f) {
                                    filter = f
                                }
                            }
                        }
                        .padding(.horizontal, 2)
                    }
                    .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }

                // ── Chores or empty state ──────────────────────────────────
                if filteredChores.isEmpty {
                    Section {
                        emptyState
                            .listRowBackground(Color.clear)
                    }
                } else {
                    Section {
                        ForEach(filteredChores) { chore in
                            ChoreRow(chore: chore)
                        }
                    }
                }

                // ── Suggest a chore ────────────────────────────────────────
                Section {
                    Button {
                        showSuggestChore = true
                    } label: {
                        Label("Suggest a Chore", systemImage: "lightbulb")
                    }
                } footer: {
                    Text("Propose a task and amount — your parent can approve it.")
                }
            }
            .navigationTitle("Earn")
            .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 80) }
            .sheet(isPresented: $showSuggestChore) {
                SuggestChoreView()
            }
        }
    }

    // MARK: - Streak strip

    private var streakStrip: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label("Weekly Streak", systemImage: "flame.fill")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.orange)
                Spacer()
                Text("\(user.streakDays.filter { $0 }.count)/7 days")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 6) {
                let labels = ["M", "T", "W", "T", "F", "S", "S"]
                ForEach(0..<7, id: \.self) { i in
                    let done = i < user.streakDays.count && user.streakDays[i]
                    VStack(spacing: 4) {
                        Circle()
                            .fill(done ? Color.orange : Color.secondary.opacity(0.15))
                            .frame(width: 32, height: 32)
                            .overlay {
                                if done {
                                    Image(systemName: "flame.fill")
                                        .font(.caption2)
                                        .foregroundStyle(.white)
                                } else {
                                    Text(labels[i])
                                        .font(.caption2.weight(.medium))
                                        .foregroundStyle(.secondary)
                                }
                            }
                        // today indicator
                        Circle()
                            .fill(i == Calendar.current.component(.weekday, from: Date()) - 2 ? Color.orange : Color.clear)
                            .frame(width: 4, height: 4)
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }

    // MARK: - Empty state

    private var emptyState: some View {
        VStack(spacing: 16) {
            Text("🧹")
                .font(.system(size: 48))
            Text("No chores yet")
                .font(.headline)
            Text("Ask your parent to add chores, or suggest one yourself.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button {
                showSuggestChore = true
            } label: {
                Label("Suggest a Chore", systemImage: "lightbulb")
                    .font(.subheadline.weight(.semibold))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(.orange.opacity(0.12), in: RoundedRectangle(cornerRadius: 10))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
    }
}

// MARK: - ChoreRow

private struct ChoreRow: View {
    @Environment(User.self) private var user

    let chore: Chore
    @State private var showPhotoConfirm = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                // Category icon
                Image(systemName: chore.category.icon)
                    .font(.body)
                    .foregroundStyle(.orange)
                    .frame(width: 36, height: 36)
                    .background(.orange.opacity(0.1), in: Circle())

                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(chore.title)
                            .font(.subheadline.weight(.medium))
                        if chore.suggestedByKid {
                            Text("Your idea")
                                .font(.caption2.weight(.semibold))
                                .padding(.horizontal, 5).padding(.vertical, 2)
                                .background(.purple.opacity(0.12), in: Capsule())
                                .foregroundStyle(.purple)
                        }
                    }
                    Text(chore.amount, format: .currency(code: "USD"))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                // Status pill
                StatusPill(status: chore.status)
            }

            // Action row
            HStack(spacing: 10) {
                if chore.requiresPhoto && !chore.hasPhotoProof && chore.status == .toDo {
                    Button {
                        showPhotoConfirm = true
                    } label: {
                        Label("Add Photo", systemImage: "camera")
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.blue)
                    }
                    .buttonStyle(.plain)
                }

                Spacer()

                actionButton(for: chore)
            }
        }
        .padding(.vertical, 4)
        .alert("Photo submitted! ✅", isPresented: $showPhotoConfirm) {
            Button("OK") {
                markPhotoProof()
            }
        } message: {
            Text("Your photo will be reviewed by a parent.")
        }
    }

    @ViewBuilder
    private func actionButton(for chore: Chore) -> some View {
        switch chore.status {
        case .toDo:
            Button {
                markDone()
            } label: {
                Text("Mark Done")
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 12).padding(.vertical, 5)
                    .background(.green.opacity(0.12), in: Capsule())
                    .foregroundStyle(.green)
            }
            .buttonStyle(.plain)

        case .needsRedo:
            Button {
                markDone()
            } label: {
                Text("Try Again")
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 12).padding(.vertical, 5)
                    .background(.red.opacity(0.12), in: Capsule())
                    .foregroundStyle(.red)
            }
            .buttonStyle(.plain)

        case .waitingOnParent:
            Text("Waiting…")
                .font(.caption)
                .foregroundStyle(.secondary)

        case .approved:
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
        }
    }

    private func markDone() {
        guard let i = user.chores.firstIndex(where: { $0.id == chore.id }) else { return }
        user.chores[i].status = .waitingOnParent
    }

    private func markPhotoProof() {
        guard let i = user.chores.firstIndex(where: { $0.id == chore.id }) else { return }
        user.chores[i].hasPhotoProof = true
    }
}

// MARK: - StatusPill

private struct StatusPill: View {
    let status: ChoreStatus

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: status.icon)
                .font(.caption2)
            Text(status.rawValue)
                .font(.caption2.weight(.semibold))
        }
        .padding(.horizontal, 8).padding(.vertical, 4)
        .background(status.color.opacity(0.12), in: Capsule())
        .foregroundStyle(status.color)
    }
}

// MARK: - FilterChip

private struct FilterChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.subheadline.weight(isSelected ? .semibold : .regular))
                .padding(.horizontal, 14).padding(.vertical, 7)
                .background(isSelected ? Color.orange : Color.secondary.opacity(0.1), in: Capsule())
                .foregroundStyle(isSelected ? .white : .secondary)
        }
        .buttonStyle(.plain)
        .animation(.spring(duration: 0.2), value: isSelected)
    }
}

// MARK: - Preview

#Preview {
    EarnView()
        .environment(User.sample)
}
