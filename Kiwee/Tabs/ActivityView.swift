import SwiftUI

struct ActivityView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(0..<6) { index in
                        HStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(KiweeColor.surface3)
                                .frame(width: 40, height: 40)
                                .overlay {
                                    Image(systemName: "arrow.left.arrow.right")
                                        .font(.system(size: 14))
                                        .foregroundStyle(KiweeColor.textPrimary)
                                }

                            VStack(alignment: .leading, spacing: 2) {
                                // Transaction name — Inter 600 (spec §16 Level 1)
                                Text(["Allowance", "Chore Pay", "Birthday Gift", "Spent at Store", "Savings Transfer", "Refund"][index])
                                    .font(.inter(size: 16, weight: .semibold))
                                    .foregroundStyle(KiweeColor.textPrimary)
                                // Date — Inter 400 (spec §16 Level 2)
                                Text(["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"][index])
                                    .font(.kiwee(.transactionMeta))
                                    .foregroundStyle(KiweeColor.textSecondary)
                            }

                            Spacer()

                            // Amount — Inter 600 (spec §16 Level 3)
                            Text(["+$10.00", "+$5.00", "+$25.00", "-$7.50", "-$15.00", "+$3.00"][index])
                                .font(.kiwee(.transactionAmount))
                                .foregroundStyle([true, true, true, false, false, true][index] ? KiweeColor.success : KiweeColor.textPrimary)
                        }
                        .padding(.vertical, 4)
                    }
                } header: {
                    Text("This Week")
                        .font(.kiwee(.overline))
                }

                Section {
                    ForEach(0..<5) { index in
                        HStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(KiweeColor.surface3)
                                .frame(width: 40, height: 40)
                                .overlay {
                                    Image(systemName: "clock")
                                        .font(.system(size: 14))
                                        .foregroundStyle(KiweeColor.textTertiary)
                                }

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Transaction \(index + 1)")
                                    .font(.inter(size: 16, weight: .semibold))
                                    .foregroundStyle(KiweeColor.textPrimary)
                                Text("Last week")
                                    .font(.kiwee(.transactionMeta))
                                    .foregroundStyle(KiweeColor.textSecondary)
                            }

                            Spacer()

                            Text("-$\(index + 2).00")
                                .font(.kiwee(.transactionAmount))
                                .foregroundStyle(KiweeColor.textPrimary)
                        }
                        .padding(.vertical, 4)
                    }
                } header: {
                    Text("Last Week")
                        .font(.kiwee(.overline))
                }
            }
            .navigationTitle("Activity")
        }
    }
}
