import SwiftUI

struct PaymentMethodsView: View {
    @Environment(ParentUser.self) private var parent
    @State private var showAddSheet = false

    var body: some View {
        @Bindable var parent = parent

        List {
            Section {
                ForEach($parent.paymentMethods) { $method in
                    PaymentMethodRow(method: $method) {
                        setDefault(id: method.id)
                    }
                }
                .onDelete(perform: removeMethod)
            } header: {
                Text("Linked accounts")
            } footer: {
                Text("Full card and account numbers are never stored or displayed.")
            }

            Section {
                Button {
                    showAddSheet = true
                } label: {
                    Label("Add Payment Method", systemImage: "plus.circle.fill")
                }
            }
        }
        .navigationTitle("Payment Methods")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            EditButton()
        }
        .sheet(isPresented: $showAddSheet) {
            AddPaymentMethodView()
        }
    }

    private func setDefault(id: UUID) {
        for i in parent.paymentMethods.indices {
            parent.paymentMethods[i].isDefault = parent.paymentMethods[i].id == id
        }
    }

    private func removeMethod(at offsets: IndexSet) {
        // Prevent removing the default — swap default first if needed
        let methods = parent.paymentMethods
        for i in offsets {
            if methods[i].isDefault && methods.count > 1 {
                // Assign default to the next available method
                let nextIndex = methods.indices.first { $0 != i }!
                parent.paymentMethods[nextIndex].isDefault = true
            }
        }
        parent.paymentMethods.remove(atOffsets: offsets)
    }
}

// MARK: - PaymentMethodRow

private struct PaymentMethodRow: View {
    @Binding var method: PaymentMethod
    let onSetDefault: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: method.type.icon)
                .font(.title3)
                .foregroundStyle(.tint)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(method.institutionName)
                        .font(.subheadline.weight(.medium))
                    if method.isDefault {
                        Text("Default")
                            .font(.caption2.weight(.semibold))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.green.opacity(0.15), in: Capsule())
                            .foregroundStyle(.green)
                    }
                }
                Text(method.maskedNumber)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .contentShape(Rectangle())
        .swipeActions(edge: .leading) {
            if !method.isDefault {
                Button {
                    onSetDefault()
                } label: {
                    Label("Set Default", systemImage: "star.fill")
                }
                .tint(.yellow)
            }
        }
    }
}

// MARK: - AddPaymentMethodView

struct AddPaymentMethodView: View {
    @Environment(ParentUser.self) private var parent
    @Environment(\.dismiss) private var dismiss

    @State private var selectedType: PaymentMethodType = .bankAccount
    @State private var institutionName = ""
    @State private var lastFour = ""

    private var canAdd: Bool {
        !institutionName.trimmingCharacters(in: .whitespaces).isEmpty && lastFour.count == 4
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Account Type") {
                    Picker("Type", selection: $selectedType) {
                        ForEach(PaymentMethodType.allCases, id: \.rawValue) { type in
                            Label(type.label, systemImage: type.icon).tag(type)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section {
                    TextField("Institution name", text: $institutionName)
                    HStack {
                        Text("•••• •••• ••••")
                            .foregroundStyle(.secondary)
                        Spacer()
                        TextField("Last 4", text: $lastFour)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                            .frame(width: 56)
                            .onChange(of: lastFour) { _, new in
                                lastFour = String(new.filter(\.isNumber).prefix(4))
                            }
                    }
                } header: {
                    Text("Details")
                } footer: {
                    Text("Only the last 4 digits are stored to identify this account.")
                }
            }
            .navigationTitle("Add Payment Method")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        let method = PaymentMethod(
                            id: UUID(),
                            type: selectedType,
                            institutionName: institutionName.trimmingCharacters(in: .whitespaces),
                            maskedNumber: "•••• \(lastFour)",
                            isDefault: parent.paymentMethods.isEmpty
                        )
                        parent.paymentMethods.append(method)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(!canAdd)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        PaymentMethodsView()
            .environment(ParentUser.sample)
    }
}
