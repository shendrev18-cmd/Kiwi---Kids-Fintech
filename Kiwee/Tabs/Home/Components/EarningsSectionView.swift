import SwiftUI

// MARK: - EarningsSectionView

/// Vertical stack of earning opportunity cards with a section header.
struct EarningsSectionView: View {
    let opportunities: [EarningOpportunity]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(
                title: "Ways to Earn",
                systemImage: "star.fill",
                action: { /* navigate to EarnView */ }
            )

            VStack(spacing: KiweeTheme.Spacing.cardSpacing) {
                ForEach(opportunities) { opportunity in
                    EarningOpportunityCard(opportunity: opportunity)
                }
            }
        }
    }
}
