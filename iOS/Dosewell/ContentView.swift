import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: DosewellStore
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showingAdd = false
    @State private var showingPaywall = false
    @State private var showingSettings = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.doses) { entry in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(entry.petName).font(Theme.headlineFont)
                        Text("\(entry.medicationName)")
                            .font(Theme.captionFont)
                            .foregroundStyle(.secondary)
                    }
                }
                .onDelete { store.remove(at: $0) }
            }
            .navigationTitle("Dosewell")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { showingSettings = true } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityIdentifier("main.settingsButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.canAdd(isPro: purchases.isPro) {
                            showingAdd = true
                        } else {
                            showingPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .accessibilityIdentifier("main.addButton")
                }
            }
            .sheet(isPresented: $showingAdd) { AddMedicationDoseView() }
            .sheet(isPresented: $showingPaywall) { PaywallView() }
            .sheet(isPresented: $showingSettings) { SettingsView() }
        }
    }
}

struct AddMedicationDoseView: View {
    @EnvironmentObject var store: DosewellStore
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) private var dismiss
    @State private var petName = ""
    @State private var medicationName = ""
    @State private var dose = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Pet Name", text: $petName)
                        .accessibilityIdentifier("addMedicationDose.petNameField")
                    TextField("Medication", text: $medicationName)
                    TextField("Dose", text: $dose)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture { hideKeyboard() }
            .navigationTitle("Add Entry")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let entry = MedicationDose(petName: petName.isEmpty ? "Pet Name" : petName, medicationName: medicationName.isEmpty ? "Medication" : medicationName, dose: dose.isEmpty ? "Dose" : dose)
                        _ = store.add(entry, isPro: purchases.isPro)
                        dismiss()
                    }
                    .accessibilityIdentifier("addMedicationDose.saveButton")
                }
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
