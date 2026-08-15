import SwiftUI

// MARK: - SavingsGoalCard

/// Fixed-width card showing a single savings goal with a custom progress bar.
/// Designed for a horizontal snapping scroll row.
struct SavingsGoalCard: View {
    let goal: SavingsGoal

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Icon + percentage header
            HStack {
                Image(systemName: goal.iconSymbol)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(goal.colorTheme.color)
                    .frame(width: 44, height: 44)
                    .background(
                        goal.colorTheme.color.opacity(0.14),
                        in: RoundedRectangle(cornerRadius: KiweeTheme.Radius.icon)
                    )

                Spacer()

                Text("\(goal.progressPercent)%")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(goal.colorTheme.color)
            }

            // Goal name
            Text(goal.name)
                .font(KiweeTheme.Typography.cardTitle)
                .lineLimit(2)
                .minimumScaleFactor(0.85)

            // Custom two-capsule progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(.quaternarySystemFill))
                        .frame(height: 7)
                    Capsule()
                        .fill(goal.colorTheme.progressGradient)
                        .frame(width: geo.size.width * goal.progress, height: 7)
                }
            }
            .frame(height: 7)
            .accessibilityValue("\(goal.progressPercent)% saved")

            // Amount progress
            HStack(spacing: 3) {
                Text(goal.currentAmount, format: .currency(code: "USD"))
                    .font(.caption.weight(.medium))
                Text("of")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(goal.targetAmount, format: .currency(code: "USD"))
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(KiweeTheme.Spacing.cardPad)
        .frame(width: 178)
        .background(
            Color(.secondarySystemGroupedBackground),
            in: RoundedRectangle(cornerRadius: KiweeTheme.Radius.card)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(
            "\(goal.name) savings goal, \(goal.progressPercent)% complete"
        )
    }
}
