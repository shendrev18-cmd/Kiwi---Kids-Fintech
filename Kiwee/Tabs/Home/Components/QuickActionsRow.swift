import SwiftUI

// MARK: - QuickActionsRow

/// Four symmetrical shortcut buttons (Add Money, Send, Goals, Earn)
/// grouped inside a material card.
struct QuickActionsRow: View {
    var body: some View {
        HStack(spacing: 0) {
            QuickActionButton(
                title: "Add Money",
                symbol: "plus.circle.fill",
                tint: .kiweeGreen
            ) { }

            QuickActionButton(
                title: "Send",
                symbol: "paperplane.fill",
                tint: .kiweeTeal
            ) { }

            QuickActionButton(
                title: "Goals",
                symbol: "target",
                tint: KiweeTheme.Colors.goalPurple
            ) { }

            QuickActionButton(
                title: "Earn",
                symbol: "star.fill",
                tint: KiweeTheme.Colors.rewardGold
            ) { }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 4)
        .background(
            Color(.secondarySystemGroupedBackground),
            in: RoundedRectangle(cornerRadius: KiweeTheme.Radius.card)
        )
    }
}

// MARK: - QuickActionButton

private struct QuickActionButton: View {
    let title: String
    let symbol: String
    let tint: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: symbol)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(tint)
                    .frame(width: 52, height: 52)
                    .background(tint.opacity(0.14), in: Circle())

                Text(title)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.primary)
            }
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
        .accessibilityLabel(title)
    }
}
