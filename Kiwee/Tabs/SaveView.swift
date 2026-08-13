import SwiftUI

struct SaveView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(spacing: 8) {
                        Image(systemName: "target")
                            .font(.system(size: 44))
                            .foregroundStyle(.purple)
                        Text("3 Active Goals")
                            .font(.headline)
                        Text("$87.50 saved so far")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .listRowBackground(
                        LinearGradient(
                            colors: [.purple.opacity(0.2), .indigo.opacity(0.15)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                }

                Section("Savings Goals") {
                    ForEach(0..<3) { index in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: ["bicycle", "headphones", "teddybear"][index])
                                    .foregroundStyle(.purple)
                                Text(["New Bike", "Headphones", "Stuffed Animal"][index])
                                    .font(.subheadline.weight(.medium))
                                Spacer()
                                Text(["$45/$120", "$32/$80", "$10.50/$25"][index])
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            ProgressView(value: [0.375, 0.4, 0.42][index])
                                .tint(.purple)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Save")
        }
    }
}
