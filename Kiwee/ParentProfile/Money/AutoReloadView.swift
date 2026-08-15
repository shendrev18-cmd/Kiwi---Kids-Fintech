import SwiftUI

struct AutoReloadView: View {
    @Environment(ParentUser.self) private var parent

    var body: some View {
        @Bindable var parent = parent

        List {
            Section {
                Toggle(isOn: $parent.autoReloadEnabled) {
                    Label("Auto-Reload", systemImage: "arrow.clockwise.circle")
                }
            } footer: {
                Text("Automatically top up the family balance when it runs low.")
            }

            if parent.autoReloadEnabled {
                Section {
                    Stepper(
                        value: $parent.autoReloadTopUpAmount,
                        in: 10...500,
                        step: 10
                    ) {
                        HStack {
                            Text("Top-up amount")
                            Spacer()
                            Text(parent.autoReloadTopUpAmount, format: .currency(code: "USD"))
                                .foregroundStyle(.secondary)
                        }
                    }

                    Stepper(
                        value: $parent.autoReloadThreshold,
                        in: 5...200,
                        step: 5
                    ) {
                        HStack {
                            Text("Trigger when below")
                            Spacer()
                            Text(parent.autoReloadThreshold, format: .currency(code: "USD"))
                                .foregroundStyle(.secondary)
                        }
                    }
                } header: {
                    Text("Settings")
                } footer: {
                    Text("Kiwee will add \(parent.autoReloadTopUpAmount, format: .currency(code: "USD")) from your default payment method whenever the balance drops below \(parent.autoReloadThreshold, format: .currency(code: "USD")).")
                }

                Section("Default Payment Method") {
                    if let defaultMethod = parent.paymentMethods.first(where: { $0.isDefault }) {
                        HStack(spacing: 12) {
                            Image(systemName: defaultMethod.type.icon)
                                .foregroundStyle(.tint)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(defaultMethod.institutionName)
                                    .font(.subheadline.weight(.medium))
                                Text(defaultMethod.maskedNumber)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    } else {
                        Label("No payment method linked", systemImage: "exclamationmark.triangle")
                            .foregroundStyle(.orange)
                    }
                }
            }
        }
        .navigationTitle("Auto-Reload")
        .navigationBarTitleDisplayMode(.inline)
        .animation(.default, value: parent.autoReloadEnabled)
    }
}

#Preview {
    NavigationStack {
        AutoReloadView()
            .environment(ParentUser.sample)
    }
}
