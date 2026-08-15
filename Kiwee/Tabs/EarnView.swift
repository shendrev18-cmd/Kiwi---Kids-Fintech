import SwiftUI

struct EarnView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(spacing: 8) {
                        Image(systemName: "piggybank.fill")
                            .font(.system(size: 44))
                            .foregroundStyle(.orange)
                        Text("$32.00 earned this month")
                            .font(.headline)
                        Text("Keep it up!")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .listRowBackground(
                        LinearGradient(
                            colors: [.orange.opacity(0.2), .yellow.opacity(0.15)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                }

                Section("Available Chores") {
                    ForEach(0..<6) { index in
                        HStack {
                            Image(systemName: ["trash", "leaf", "cup.and.saucer", "dog", "bed.double", "book"][index])
                                .font(.title3)
                                .foregroundStyle(.orange)
                                .frame(width: 36)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(["Take Out Trash", "Mow Lawn", "Wash Dishes", "Walk the Dog", "Make Bed", "Read 30 min"][index])
                                    .font(.subheadline.weight(.medium))
                                Text(["Daily", "Weekly", "Daily", "Daily", "Daily", "Daily"][index])
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Text(["$1.00", "$5.00", "$2.00", "$3.00", "$0.50", "$1.50"][index])
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(.orange)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Earn")
        }
    }
}
