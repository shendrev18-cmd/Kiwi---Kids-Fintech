import SwiftUI

struct FamilyView: View {
    private struct FamilyMember {
        let name: String
        let role: String
        let initials: String
        let colors: [Color]
        let verified: Bool
    }

    private let members: [FamilyMember] = [
        FamilyMember(name: "Kiwee Kid",  role: "Kid Account",    initials: "KK", colors: [.pink, .purple],         verified: true),
        FamilyMember(name: "Mom",        role: "Parent",         initials: "M",  colors: [.blue, .teal],           verified: true),
        FamilyMember(name: "Dad",        role: "Parent",         initials: "D",  colors: [.green, .mint],          verified: true),
        FamilyMember(name: "Little Sis", role: "Kid Account",    initials: "LS", colors: [.orange, .yellow],       verified: false),
    ]

    var body: some View {
        List {
            Section {
                ForEach(members, id: \.name) { member in
                    HStack(spacing: 14) {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: member.colors,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 40, height: 40)
                            .overlay {
                                Text(member.initials)
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundStyle(.white)
                            }

                        VStack(alignment: .leading, spacing: 2) {
                            Text(member.name)
                                .font(.subheadline.weight(.medium))
                            Text(member.role)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        if member.verified {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundStyle(.green)
                                .font(.body)
                        } else {
                            Text("Pending")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }

            Section {
                Button {
                    // TODO: Invite flow
                } label: {
                    Label("Invite a Family Member", systemImage: "person.badge.plus")
                }
            }
        }
        .navigationTitle("Family")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        FamilyView()
    }
}
