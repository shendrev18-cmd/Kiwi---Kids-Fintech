import SwiftUI

struct AboutKiweeView: View {
    var body: some View {
        List {
            // MARK: Hero card
            Section {
                VStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 22)
                        .fill(
                            LinearGradient(
                                colors: [.green, .mint],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                        .overlay {
                            Text("🥝")
                                .font(.system(size: 44))
                        }

                    Text("Kiwee")
                        .font(.title.bold())

                    Text("Version 1.0")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Text("The fun way to earn, save, and learn about money! 🌱")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .listRowBackground(
                    LinearGradient(
                        colors: [.green.opacity(0.1), .mint.opacity(0.08)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            }

            // MARK: Acknowledgements
            Section("Made With") {
                Label("Swift & SwiftUI", systemImage: "swift")
                Label("Love for kids everywhere", systemImage: "heart")
                Label("Lots of 🥝 juice",          systemImage: "cup.and.saucer")
            }
        }
        .navigationTitle("About Kiwee")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        AboutKiweeView()
    }
}
