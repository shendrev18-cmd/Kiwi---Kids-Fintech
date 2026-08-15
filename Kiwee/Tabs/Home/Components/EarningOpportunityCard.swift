import SwiftUI

// MARK: - EarningOpportunityCard

/// Full-width horizontal card for a single chore / earning opportunity.
struct EarningOpportunityCard: View {
    let opportunity: EarningOpportunity

    var body: some View {
        HStack(spacing: 14) {
            // Large icon block
            Image(systemName: opportunity.iconSymbol)
                .font(.system(size: 26, weight: .medium))
                .foregroundStyle(opportunity.colorTheme.color)
                .frame(width: 58, height: 58)
                .background(
                    opportunity.colorTheme.color.opacity(0.14),
                    in: RoundedRectangle(cornerRadius: 16)
                )

            // Title, description, frequency pill
            VStack(alignment: .leading, spacing: 4) {
                Text(opportunity.title)
                    .font(KiweeTheme.Typography.cardTitle)

                Text(opportunity.choreDescription)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                Text(opportunity.frequency.displayText)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(opportunity.colorTheme.color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(
                        opportunity.colorTheme.color.opacity(0.12),
                        in: Capsule()
                    )
            }

            Spacer(minLength: 8)

            // Reward badge
            Text(opportunity.reward, format: .currency(code: "USD"))
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(opportunity.colorTheme.color, in: Capsule())
        }
        .padding(KiweeTheme.Spacing.cardPad)
        .background(
            Color(.secondarySystemGroupedBackground),
            in: RoundedRectangle(cornerRadius: KiweeTheme.Radius.card)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(
            "\(opportunity.title). Earn \(opportunity.reward.formatted(.currency(code: "USD"))). \(opportunity.frequency.displayText)."
        )
    }
}
