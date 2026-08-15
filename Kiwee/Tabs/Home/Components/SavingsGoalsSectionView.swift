import SwiftUI

// MARK: - SavingsGoalsSectionView

/// Horizontal snapping scroll of savings goal cards with full-bleed edges.
struct SavingsGoalsSectionView: View {
    let goals: [SavingsGoal]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(
                title: "Savings Goals",
                systemImage: "target",
                action: { /* navigate to SaveView */ }
            )
            .padding(.horizontal, 0) // already inside screen padding

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: KiweeTheme.Spacing.cardSpacing) {
                    ForEach(goals) { goal in
                        SavingsGoalCard(goal: goal)
                    }
                    AddGoalCard()
                }
                .padding(.horizontal, KiweeTheme.Spacing.screenH)
                .scrollTargetLayout()
            }
            // Negative padding escapes the parent VStack's horizontal padding,
            // letting cards bleed to the screen edges.
            .padding(.horizontal, -KiweeTheme.Spacing.screenH)
            .scrollTargetBehavior(.viewAligned)
            .scrollClipDisabled()
        }
    }
}
