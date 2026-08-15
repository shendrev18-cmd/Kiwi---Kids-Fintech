import SwiftUI

// MARK: - BalanceHeroCard

/// Full-bleed hero section matching the reference screenshot:
/// - Near-black background with a green radial glow from lower-center/left
/// - Top bar: avatar | Spending/Saving picker | rewards pill
/// - Centered: "Card balance" label + huge raw balance number (no symbol)
/// - Bottom: lime-green pill CTA with side margins (not full-width)
struct BalanceHeroCard: View {
    let user: User

    @State private var selectedTab: BalanceTab = .spending

    var body: some View {
        ZStack(alignment: .top) {
            background

            VStack(spacing: 0) {
                topBar
                    .padding(.horizontal, 24)
                    .padding(.top, 20)

                // Space between top bar and balance
                Spacer()
                    .frame(height: 36)

                balanceBlock

                Spacer()
                    .frame(height: 40)

                requestMoneyButton
                    .padding(.horizontal, 40) // side margins — not full-width
                    .padding(.bottom, 32)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 340)
        // Escape the parent ScrollView's horizontal padding → true full-bleed
        .padding(.horizontal, -KiweeTheme.Spacing.screenH)
    }

    // MARK: - Background

    private var background: some View {
        ZStack {
            // Base: near-black with a very subtle dark-green tint
            Color(red: 0.02, green: 0.05, blue: 0.04)
                .ignoresSafeArea()

            // Primary glow: radiates from lower-left, matching the reference
            RadialGradient(
                colors: [
                    Color(red: 0.06, green: 0.42, blue: 0.22).opacity(0.95),
                    Color(red: 0.04, green: 0.25, blue: 0.14).opacity(0.70),
                    Color(red: 0.02, green: 0.10, blue: 0.06).opacity(0.40),
                    .clear,
                ],
                center: .init(x: 0.20, y: 0.85),
                startRadius: 10,
                endRadius: 350
            )

            // Secondary fill: a softer glow at the center to illuminate the balance text
            RadialGradient(
                colors: [
                    Color(red: 0.05, green: 0.30, blue: 0.16).opacity(0.55),
                    .clear,
                ],
                center: .init(x: 0.50, y: 0.65),
                startRadius: 0,
                endRadius: 260
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Top bar

    private var topBar: some View {
        HStack(alignment: .center, spacing: 0) {
            avatarCircle

            Spacer()

            spendingSavingPicker

            Spacer()

            rewardsPill
        }
    }

    // Lime-yellow circle with a cartoon-style kid silhouette
    private var avatarCircle: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.84, green: 0.96, blue: 0.28),
                            Color(red: 0.65, green: 0.84, blue: 0.18),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 52, height: 52)

            // Stylised kid character using layered SF Symbols
            VStack(spacing: -6) {
                // Head
                Circle()
                    .fill(Color(red: 0.93, green: 0.78, blue: 0.58))
                    .frame(width: 22, height: 22)

                // Body / shoulders
                Image(systemName: "person.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color(red: 0.22, green: 0.55, blue: 0.16))
                    .offset(y: -2)
            }
            .clipShape(Circle().inset(by: 4))
        }
        .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
        .accessibilityLabel("Avatar for \(user.firstName)")
    }

    private var spendingSavingPicker: some View {
        HStack(spacing: 28) {
            ForEach(BalanceTab.allCases) { tab in
                Button {
                    withAnimation(.easeInOut(duration: 0.18)) {
                        selectedTab = tab
                    }
                } label: {
                    VStack(spacing: 7) {
                        Text(tab.title)
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                selectedTab == tab
                                    ? .white
                                    : Color.white.opacity(0.40)
                            )
                            .animation(.easeInOut(duration: 0.18), value: selectedTab)

                        // Active dot indicator
                        Circle()
                            .fill(Color(red: 0.38, green: 0.92, blue: 0.50))
                            .frame(width: 5, height: 5)
                            .scaleEffect(selectedTab == tab ? 1 : 0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedTab)
                    }
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(selectedTab == tab ? .isSelected : [])
            }
        }
    }

    private var rewardsPill: some View {
        HStack(spacing: 8) {
            // Coin icon: gradient ring around "G"
            ZStack {
                Circle()
                    .fill(Color.black.opacity(0.30))
                    .frame(width: 30, height: 30)

                Circle()
                    .strokeBorder(
                        AngularGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.25, green: 0.85, blue: 0.45),
                                Color(red: 0.50, green: 0.95, blue: 0.60),
                                Color(red: 0.25, green: 0.85, blue: 0.45),
                            ]),
                            center: .center
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 30, height: 30)

                Text("G")
                    .font(.system(size: 13, weight: .black, design: .rounded))
                    .foregroundStyle(Color(red: 0.30, green: 0.90, blue: 0.50))
            }

            Text("835")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
        }
        .padding(.leading, 8)
        .padding(.trailing, 14)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.10), in: Capsule())
        .overlay(Capsule().strokeBorder(Color.white.opacity(0.08), lineWidth: 0.5))
        .accessibilityLabel("835 Kiwee coins")
    }

    // MARK: - Balance block

    private var balanceBlock: some View {
        VStack(spacing: 8) {
            // Subtitle — muted, matches the reference colour
            Text("Card balance, USD")
                .font(.system(size: 15, weight: .regular, design: .rounded))
                .foregroundStyle(Color(red: 0.55, green: 0.75, blue: 0.60).opacity(0.80))
                .tracking(0.2)

            // Giant balance — no currency symbol, just the number
            Text(formattedBalance)
                .font(.system(size: 64, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)
                .minimumScaleFactor(0.60)
                .lineLimit(1)
                .shadow(color: Color(red: 0.10, green: 0.60, blue: 0.30).opacity(0.40),
                        radius: 20, x: 0, y: 4)
                .accessibilityLabel(
                    "Balance: \(user.balance.formatted(.currency(code: "USD")))"
                )
        }
    }

    /// Formats the balance as "1,340.25" — grouped digits, 2 decimal places, no symbol.
    private var formattedBalance: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: user.balance as NSDecimalNumber) ?? "0.00"
    }

    // MARK: - Request money button

    private var requestMoneyButton: some View {
        Button {
            // TODO: request money action
        } label: {
            Text("Request money")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.04, green: 0.10, blue: 0.04))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    // Bright lime-green matching the reference
                    LinearGradient(
                        colors: [
                            Color(red: 0.58, green: 0.96, blue: 0.40),
                            Color(red: 0.48, green: 0.90, blue: 0.32),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    in: Capsule()
                )
                .shadow(
                    color: Color(red: 0.40, green: 0.90, blue: 0.30).opacity(0.40),
                    radius: 12, x: 0, y: 6
                )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Request money")
    }
}

// MARK: - BalanceTab

private enum BalanceTab: String, CaseIterable, Identifiable {
    case spending, saving

    var id: String { rawValue }

    var title: String {
        switch self {
        case .spending: "Spending"
        case .saving:   "Saving"
        }
    }
}
