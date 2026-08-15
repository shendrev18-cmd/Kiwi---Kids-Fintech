import SwiftUI

// MARK: - CelebrationStepView

/// Final onboarding screen with confetti animation and the user's new avatar.
struct CelebrationStepView: View {
    let viewModel: OnboardingViewModel
    let onComplete: () -> Void

    @State private var avatarScale: CGFloat = 0.3
    @State private var avatarOpacity: Double = 0
    @State private var textOpacity: Double = 0
    @State private var showConfetti: Bool = false

    var body: some View {
        ZStack {
            // Confetti particles
            if showConfetti {
                ConfettiView()
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
            }

            VStack(spacing: 0) {
                Spacer()

                // Avatar with celebratory ring
                ZStack {
                    // Outer glow ring
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    viewModel.selectedGradient.colors.first?.opacity(0.3) ?? .clear,
                                    .clear
                                ],
                                center: .center,
                                startRadius: 60,
                                endRadius: 120
                            )
                        )
                        .frame(width: 200, height: 200)

                    GradientAvatarPreview(
                        initials: viewModel.avatarInitials,
                        gradientColors: viewModel.selectedGradient.colors,
                        size: 140
                    )
                }
                .scaleEffect(avatarScale)
                .opacity(avatarOpacity)

                Spacer().frame(height: 32)

                // Celebration text
                VStack(spacing: 12) {
                    Text("You're all set! 🎉")
                        .font(.lexend(.title, weight: .bold))

                    Text("Welcome to Kiwee, \(viewModel.userName.isEmpty ? "friend" : viewModel.userName)!")
                        .font(.figtree(.title3, weight: .medium))
                        .foregroundStyle(.secondary)

                    Text("Your \(viewModel.selectedAccountType.label) account is ready.")
                        .font(.figtree(.body, weight: .regular))
                        .foregroundStyle(.secondary)
                }
                .opacity(textOpacity)
                .multilineTextAlignment(.center)
                .padding(.horizontal, KiweeTheme.Spacing.screenH)

                Spacer()

                // Enter app button
                OnboardingButton(label: "Let's Go!") {
                    onComplete()
                }
                .padding(.horizontal, KiweeTheme.Spacing.screenH)
                .padding(.bottom, 24)
                .opacity(textOpacity)
            }
        }
        .onAppear {
            withAnimation(.spring(duration: 0.8, bounce: 0.4).delay(0.2)) {
                avatarScale = 1.0
                avatarOpacity = 1.0
            }
            withAnimation(.easeOut(duration: 0.6).delay(0.6)) {
                textOpacity = 1.0
            }
            withAnimation(.easeOut(duration: 0.3).delay(0.4)) {
                showConfetti = true
            }
        }
    }
}

// MARK: - ConfettiView

/// Lightweight confetti particle effect using Canvas + TimelineView.
private struct ConfettiView: View {
    @State private var particles: [ConfettiParticle] = ConfettiParticle.generate(count: 60)

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let now = timeline.date.timeIntervalSinceReferenceDate
                for particle in particles {
                    let age = now - particle.startTime
                    guard age > 0, age < particle.lifetime else { continue }

                    let progress = age / particle.lifetime
                    let x = particle.startX * size.width + sin(age * particle.wobbleSpeed) * particle.wobbleAmount
                    let y = particle.startY * size.height + age * particle.fallSpeed * size.height * 0.15
                    let opacity = 1.0 - (progress * progress)
                    let rotation = Angle.degrees(age * particle.spinSpeed)

                    context.opacity = opacity
                    context.translateBy(x: x, y: y)
                    context.rotate(by: rotation)

                    let rect = CGRect(
                        x: -particle.size / 2,
                        y: -particle.size / 2,
                        width: particle.size,
                        height: particle.size * (particle.isSquare ? 1 : 0.6)
                    )
                    context.fill(
                        Path(roundedRect: rect, cornerRadius: particle.isSquare ? 2 : particle.size / 2),
                        with: .color(particle.color)
                    )

                    context.rotate(by: -rotation)
                    context.translateBy(x: -x, y: -y)
                }
            }
        }
    }
}

// MARK: - ConfettiParticle

private struct ConfettiParticle {
    let startX: Double
    let startY: Double
    let size: CGFloat
    let color: Color
    let fallSpeed: Double
    let wobbleSpeed: Double
    let wobbleAmount: Double
    let spinSpeed: Double
    let isSquare: Bool
    let startTime: TimeInterval
    let lifetime: Double

    static func generate(count: Int) -> [ConfettiParticle] {
        let colors: [Color] = [
            KiweeTheme.Colors.primary,
            KiweeTheme.Colors.secondary,
            KiweeTheme.Colors.rewardGold,
            KiweeTheme.Colors.goalPurple,
            KiweeTheme.Colors.actionOrange,
            .pink, .blue, .mint
        ]
        let now = Date.timeIntervalSinceReferenceDate

        return (0..<count).map { _ in
            ConfettiParticle(
                startX: Double.random(in: 0.05...0.95),
                startY: Double.random(in: -0.2...0.1),
                size: CGFloat.random(in: 6...12),
                color: colors.randomElement()!,
                fallSpeed: Double.random(in: 0.3...0.8),
                wobbleSpeed: Double.random(in: 1.5...4.0),
                wobbleAmount: Double.random(in: 15...40),
                spinSpeed: Double.random(in: 40...200),
                isSquare: Bool.random(),
                startTime: now + Double.random(in: 0...1.5),
                lifetime: Double.random(in: 3...6)
            )
        }
    }
}

// MARK: - Preview

#Preview {
    CelebrationStepView(
        viewModel: {
            let vm = OnboardingViewModel()
            vm.userName = "Alex"
            return vm
        }(),
        onComplete: {}
    )
}
