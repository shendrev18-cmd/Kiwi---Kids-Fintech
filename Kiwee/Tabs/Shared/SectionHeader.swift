import SwiftUI

// MARK: - SectionHeader

/// Reusable section header with an optional "See All" action button.
/// Used across Home, Activity, Earn, and Save tabs.
struct SectionHeader: View {
    let title: String
    let systemImage: String
    var actionTitle: String = "See All"
    var action: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Label(title, systemImage: systemImage)
                .font(KiweeTheme.Typography.sectionHeader)
                .foregroundStyle(.primary)

            Spacer()

            if let action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.subheadline)
                        .foregroundStyle(Color.kiweeGreen)
                }
                .accessibilityLabel("See all \(title)")
            }
        }
    }
}
