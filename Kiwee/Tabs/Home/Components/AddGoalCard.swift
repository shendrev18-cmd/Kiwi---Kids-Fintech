import SwiftUI

// MARK: - AddGoalCard

/// Dashed-border placeholder card that invites the user to create a new savings goal.
/// Always appears as the last card in the horizontal goals scroll.
struct AddGoalCard: View {
    var action: (() -> Void)? = nil

    var body: some View {
        Button {
            action?()
        } label: {
            VStack(spacing: 10) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 34))
                    .foregroundStyle(Color.kiweeGreen)

                Text("New Goal")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.kiweeGreen)
            }
            .frame(width: 178, height: 160)
            .background(
                Color(.secondarySystemGroupedBackground),
                in: RoundedRectangle(cornerRadius: KiweeTheme.Radius.card)
            )
            .overlay {
                RoundedRectangle(cornerRadius: KiweeTheme.Radius.card)
                    .stroke(
                        Color.kiweeGreen.opacity(0.40) as Color,
                        style: StrokeStyle(lineWidth: 1.5, dash: [6, 4])
                    )
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Add new savings goal")
    }
}
