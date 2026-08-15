import SwiftUI

// MARK: - HomeView

/// The main Home screen. Uses a free-form ScrollView + VStack backbone
/// so each section can control its own layout, horizontal scroll, and edge bleed.
struct HomeView: View {
    @Environment(User.self) private var user
    @State private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: KiweeTheme.Spacing.sectionGap) {
                    HomeHeaderView(user: user)

                    BalanceHeroCard(user: user)

                    QuickActionsRow()

                    SavingsGoalsSectionView(goals: viewModel.activeGoals)

                    EarningsSectionView(opportunities: viewModel.featuredOpportunities)

                    RecentTransactionsSectionView(transactions: viewModel.recentTransactions)
                }
                .padding(.horizontal, KiweeTheme.Spacing.screenH)
                .padding(.top, 8)
                .padding(.bottom, 40)
            }
            .navigationBarHidden(true)
            .background(KiweeTheme.Colors.screenBackground)
        }
    }
}

// MARK: - Preview

#Preview("Home") {
    HomeView()
        .environment(User.sample)
        .preferredColorScheme(.dark)
}
