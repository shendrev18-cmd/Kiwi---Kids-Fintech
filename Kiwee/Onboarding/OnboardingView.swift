import SwiftUI

// MARK: - Onboarding View

/// The full-screen onboarding flow.
///
/// Background: a dynamic linear gradient that warms/cools based on the
/// selected avatar's seed color, pinned to the viewport (doesn't scroll).
/// Content slides horizontally between steps; back preserves prior answers.
struct OnboardingView: View {
    @Environment(KiweeTheme.self) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var viewModel = OnboardingViewModel()

    /// Dismiss callback when onboarding completes.
    var onComplete: () -> Void = {}

    var body: some View {
        ZStack {
            // ── Pinned gradient background ──────────────────────────
            avatarGradientBackground
                .ignoresSafeArea()

            // ── Content ─────────────────────────────────────────────
            VStack(spacing: 0) {
                // Top bar: back button + progress
                topBar
                    .padding(.horizontal, 20)
                    .padding(.top, 12)

                // Step content (slides horizontally)
                TabView(selection: $viewModel.currentIndex) {
                    ForEach(Array(viewModel.steps.enumerated()), id: \.element.id) { index, step in
                        stepContent(step)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(reduceMotion ? .none : .easeOut(duration: 0.35), value: viewModel.currentIndex)

                // Sticky CTA
                ctaButton
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
            }
        }
        .onChange(of: viewModel.isComplete) { _, complete in
            if complete { onComplete() }
        }
    }

    // MARK: - Background Gradient

    /// Full-bleed gradient: glow-warm → glow-mid → surface-base (bottom → top).
    /// Warm stop concentrates in the bottom ~35%.
    private var avatarGradientBackground: some View {
        let scale = theme.avatar.scale

        return LinearGradient(
            stops: [
                .init(color: glowWarm(from: scale), location: 0.0),
                .init(color: glowMid(from: scale),  location: 0.35),
                .init(color: surfaceBase(from: scale), location: 0.7),
                .init(color: surfaceBase(from: scale), location: 1.0),
            ],
            startPoint: .bottom,
            endPoint: .top
        )
        .animation(reduceMotion ? .none : .easeOut(duration: 0.4), value: theme.avatar)
    }

    /// Warm gradient stop: same hue, saturation 60-85%, lightness ~52%.
    private func glowWarm(from scale: KiweeColorScale) -> Color {
        let hsb = hsbComponents(of: scale.hero)
        return Color(
            hue: hsb.h,
            saturation: min(max(hsb.s, 0.60), 0.85),
            brightness: 0.52
        )
    }

    /// Mid gradient stop: same hue, saturation ~45%, lightness ~24%.
    private func glowMid(from scale: KiweeColorScale) -> Color {
        let hsb = hsbComponents(of: scale.hero)
        return Color(
            hue: hsb.h,
            saturation: 0.45,
            brightness: 0.24
        )
    }

    /// Surface base: same hue, saturation ≤12%, lightness 6%.
    private func surfaceBase(from scale: KiweeColorScale) -> Color {
        let hsb = hsbComponents(of: scale.hero)
        return Color(
            hue: hsb.h,
            saturation: min(hsb.s, 0.12),
            brightness: 0.06
        )
    }

    /// Extract HSB components from a SwiftUI Color.
    private func hsbComponents(of color: Color) -> (h: Double, s: Double, b: Double) {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        UIColor(color).getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return (Double(h), Double(s), Double(b))
    }

    // MARK: - Top Bar

    private var topBar: some View {
        VStack(spacing: 16) {
            HStack {
                // Back button
                if !viewModel.isFirstStep {
                    Button {
                        if reduceMotion {
                            viewModel.goBack()
                        } else {
                            withAnimation(.easeOut(duration: 0.35)) {
                                viewModel.goBack()
                            }
                        }
                    } label: {
                        Circle()
                            .fill(.white.opacity(0.12))
                            .frame(width: 36, height: 36)
                            .overlay {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(KiweeColor.textPrimary)
                            }
                    }
                } else {
                    Spacer().frame(width: 36)
                }

                Spacer()
            }

            // Segmented progress bar
            progressBar
        }
    }

    private var progressBar: some View {
        HStack(spacing: 4) {
            ForEach(0..<viewModel.steps.count, id: \.self) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(index <= viewModel.currentIndex
                          ? KiweeColor.textPrimary
                          : Color.white.opacity(0.15))
                    .frame(height: 3)
                    .animation(reduceMotion ? .none : .easeOut(duration: 0.3), value: viewModel.currentIndex)
            }
        }
    }

    // MARK: - Step Content

    @ViewBuilder
    private func stepContent(_ step: OnboardingStep) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Headline
                Text(step.headline)
                    .font(.kiwee(.heading2))
                    .foregroundStyle(KiweeColor.textPrimary)
                    .padding(.top, 24)

                // Subtitle
                Text(step.subtitle)
                    .font(.kiwee(.bodySmall))
                    .foregroundStyle(KiweeColor.textSecondary)

                // Options
                if step.type == .avatarPicker {
                    avatarPicker
                } else {
                    optionList(step)
                }

                Spacer(minLength: 80) // Room for CTA
            }
            .padding(.horizontal, 20)
        }
        .scrollIndicators(.hidden)
    }

    // MARK: - Option List

    private func optionList(_ step: OnboardingStep) -> some View {
        VStack(spacing: 12) {
            ForEach(step.options) { option in
                optionCard(option)
            }
        }
    }

    private func optionCard(_ option: OptionItem) -> some View {
        let selected = viewModel.isSelected(option.id)

        return Button {
            withAnimation(.easeOut(duration: 0.2)) {
                viewModel.toggle(option.id)
            }
        } label: {
            HStack(spacing: 14) {
                // Radio/checkbox indicator
                Circle()
                    .strokeBorder(
                        selected ? Color.clear : Color.white.opacity(0.30),
                        lineWidth: 1.5
                    )
                    .frame(width: 22, height: 22)
                    .background {
                        if selected {
                            Circle()
                                .fill(theme.personalPrimary)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .overlay {
                        if selected {
                            Image(systemName: "checkmark")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(theme.buttonText)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }

                // Label
                Text(option.label)
                    .font(.inter(size: 16, weight: .regular))
                    .foregroundStyle(KiweeColor.textPrimary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)

                Spacer()

                // Emoji icon
                Text(option.emoji)
                    .font(.system(size: 28))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .frame(minHeight: 72)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(selected ? 0.10 : 0.06))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(
                        selected ? theme.personalPrimary.opacity(0.5) : Color.clear,
                        lineWidth: 1.5
                    )
            )
        }
        .buttonStyle(OptionCardButtonStyle())
        .sensoryFeedback(.selection, trigger: selected)
    }

    // MARK: - Avatar Picker

    private var avatarPicker: some View {
        let columns = [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16),
        ]

        return LazyVGrid(columns: columns, spacing: 20) {
            ForEach(KiweeAvatar.allCases) { avatar in
                let selected = viewModel.isSelected(avatar.rawValue)

                Button {
                    if reduceMotion {
                        viewModel.toggle(avatar.rawValue)
                        theme.avatar = avatar
                    } else {
                        withAnimation(.easeOut(duration: 0.4)) {
                            viewModel.toggle(avatar.rawValue)
                            theme.avatar = avatar
                        }
                    }
                } label: {
                    VStack(spacing: 8) {
                        Circle()
                            .fill(avatar.scale.hero)
                            .frame(width: 52, height: 52)
                            .overlay {
                                Text(String(avatar.displayName.prefix(1)))
                                    .font(.lexend(size: 20, weight: .bold))
                                    .foregroundStyle(
                                        KiweeContrast.accessibleForeground(on: avatar.scale.hero)
                                    )
                            }
                            .overlay {
                                if selected {
                                    Circle()
                                        .strokeBorder(KiweeColor.textPrimary, lineWidth: 3)
                                }
                            }
                            .shadow(
                                color: selected ? avatar.glowColor : .clear,
                                radius: selected ? 12 : 0
                            )

                        Text(avatar.displayName)
                            .font(.kiwee(.labelSmall))
                            .foregroundStyle(
                                selected ? KiweeColor.textPrimary : KiweeColor.textTertiary
                            )
                    }
                }
                .buttonStyle(.plain)
                .sensoryFeedback(.selection, trigger: selected)
            }
        }
    }

    // MARK: - CTA Button

    private var ctaButton: some View {
        Button {
            if reduceMotion {
                viewModel.advance()
            } else {
                withAnimation(.easeOut(duration: 0.35)) {
                    viewModel.advance()
                }
            }
        } label: {
            Text(viewModel.ctaLabel)
                .font(.kiwee(.buttonPrimary))
                .foregroundStyle(
                    viewModel.canContinue
                        ? theme.buttonText
                        : KiweeColor.textDisabled
                )
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(
                            viewModel.canContinue
                                ? theme.personalPrimary
                                : KiweeColor.surface4
                        )
                )
        }
        .disabled(!viewModel.canContinue)
        .animation(.easeOut(duration: 0.25), value: viewModel.canContinue)
    }
}

// MARK: - Option Card Press Style

/// Scales to 0.98 on press for option cards.
private struct OptionCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}
