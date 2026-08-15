import SwiftUI

// MARK: - FeatureTourStepView

/// Three-page carousel introducing Kiwee's core features — dark themed.
struct FeatureTourStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 80)

            Text("Here's what you can do")
                .font(.lexend(.title, weight: .bold))
                .foregroundStyle(.white)
                .padding(.bottom, 8)

            Text("Swipe to explore")
                .font(.figtree(.subheadline, weight: .regular))
                .foregroundStyle(.white.opacity(0.5))

            Spacer().frame(height: 24)

            // Feature pages
            TabView(selection: $viewModel.tourPage) {
                ForEach(Array(FeatureHighlight.all.enumerated()), id: \.offset) { index, feature in
                    FeatureCard(feature: feature, theme: viewModel.theme)
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

private struct FeatureHighlight {
    let emoji: String
    let title: String
    let description: String

    static let all: [FeatureHighlight] = [
        FeatureHighlight(
            emoji: "✨",
            title: "Earn Rewards",
            description: "Complete chores and tasks to earn real money. The more you do, the more you earn!"
        ),
        FeatureHighlight(
            emoji: "🎯",
            title: "Save Smart",
            description: "Set savings goals for the things you want. Watch your progress grow every day."
        ),
        FeatureHighlight(
            emoji: "💳",
            title: "Spend Wisely",
            description: "Learn to make smart spending choices. Track where your money goes."
        ),
    ]
}

// MARK: - FeatureCard

private struct FeatureCard: View {
    let feature: FeatureHighlight
    let theme: DynamicTheme

    var body: some View {
        VStack(spacing: 24) {
            // Large emoji in a themed circle
            ZStack {
                Circle()
                    .fill(theme.accent.opacity(0.12))
                    .frame(width: 120, height: 120)

                Text(feature.emoji)
                    .font(.system(size: 52))
            }
            .shadow(color: theme.accent.opacity(0.2), radius: 20, y: 8)

            VStack(spacing: 12) {
                Text(feature.title)
                    .font(.lexend(.title3, weight: .bold))
                    .foregroundStyle(.white)

                Text(feature.description)
                    .font(.figtree(.body, weight: .regular))
                    .foregroundStyle(.white.opacity(0.5))
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
    ZStack {
        OnboardingBackground(theme: DynamicTheme())
        FeatureTourStepView(viewModel: OnboardingViewModel())
    }
    .preferredColorScheme(.dark)
}
