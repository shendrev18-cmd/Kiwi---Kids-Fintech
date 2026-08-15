import SwiftUI

struct ActivityView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("This Week") {
                    ForEach(0..<6) { index in
                        HStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(hue: 0.6 + Double(index) * 0.05, saturation: 0.4, brightness: 0.85))
                                .frame(width: 40, height: 40)
                                .overlay {
                                    Image(systemName: "arrow.left.arrow.right")
                                        .font(.system(size: 14))
                                        .foregroundStyle(.white)
                                }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(["Allowance", "Chore Pay", "Birthday Gift", "Spent at Store", "Savings Transfer", "Refund"][index])
                                    .font(.subheadline.weight(.medium))
                                Text(["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"][index])
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Text(["+$10.00", "+$5.00", "+$25.00", "-$7.50", "-$15.00", "+$3.00"][index])
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle([true, true, true, false, false, true][index] ? .green : .primary)
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section("Last Week") {
                    ForEach(0..<5) { index in
                        HStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.blue.opacity(0.2))
                                .frame(width: 40, height: 40)
                                .overlay {
                                    Image(systemName: "clock")
                                        .font(.system(size: 14))
                                        .foregroundStyle(.blue)
                                }

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Transaction \(index + 1)")
                                    .font(.subheadline.weight(.medium))
                                Text("Last week")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Text("-$\(index + 2).00")
                                .font(.subheadline.weight(.semibold))
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Activity")
        }
    }
}
