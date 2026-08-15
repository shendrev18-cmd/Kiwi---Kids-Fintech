import SwiftUI

// MARK: - FeatureTourStepView

/// Three-page carousel introducing Kiwee's core features: Earn, Save, Spend.
struct FeatureTourStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 24)

            Text("Here's what you can do")
                .font(.lexend(.title2, weight: .bold))
                .padding(.bottom, 8)

            Text("Swipe to explore")
                .font(.figtree(.subheadline, weight: .regular))
                .foregroundStyle(.secondary)

            Spacer().frame(height: 24)

            // Feature pages
            TabView(selection: $viewModel.tourPage) {
                ForEach(Array(FeatureHighlight.all.enumerated()), id: \.offset) { index, feature in
                    FeatureCard(feature: feature)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .frame(maxHeight: 400)

            Spacer()
        }
    }
}

// MARK: - FeatureHighlight

/// Data model for a single feature tour page.
private struct FeatureHighlight {
    let icon: String
    let iconColor: Color
    let title: String
    let description: String

    static let all: [FeatureHighlight] = [
        FeatureHighlight(
            icon: "sparkles",
            iconColor: KiweeTheme.Colors.rewardGold,
            title: "Earn Rewards",
            description: "Complete chores and tasks to earn real money. The more you do, the more you earn!"
        ),
        FeatureHighlight(
            icon: "target",
            iconColor: KiweeTheme.Colors.goalPurple,
            title: "Save Smart",
            description: "Set savings goals for the things you want. Watch your progress grow every day."
        ),
        FeatureHighlight(
            icon: "creditcard.fill",
            iconColor: KiweeTheme.Colors.primary,
            title: "Spend Wisely",
            description: "Learn to make smart spending choices. Track where your money goes."
        ),
    ]
}

// MARK: - FeatureCard

/// A single feature highlight card shown in the tour carousel.
private struct FeatureCard: View {
    let feature: FeatureHighlight

    var body: some View {
        VStack(spacing: 24) {
            // Large icon in a colored circle
            ZStack {
                Circle()
                    .fill(feature.iconColor.opacity(0.15))
                    .frame(width: 120, height: 120)

                Image(systemName: feature.icon)
                    .font(.system(size: 48, weight: .medium))
                    .foregroundStyle(feature.iconColor)
            }
            .shadow(color: feature.iconColor.opacity(0.2), radius: 16, y: 8)

            VStack(spacing: 12) {
                Text(feature.title)
                    .font(.lexend(.title3, weight: .bold))

                Text(feature.description)
                    .font(.figtree(.body, weight: .regular))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .frame(maxWidth: 280)
            }
        }
        .padding(.horizontal, KiweeTheme.Spacing.screenH)
        .padding(.vertical, 20)
    }
}

// MARK: - Preview

#Preview {
    FeatureTourStepView(viewModel: OnboardingViewModel())
}
