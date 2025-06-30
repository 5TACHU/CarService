import SwiftUI

struct EditRepairView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var repair: Repair //oryginalny obiekt z bazy
    @State private var mileage: String
    @State private var cost: String
    @State private var descriptionText: String
    @State private var date = Date()

    init(repair: Repair) {
        self.repair = repair
        _mileage = State(initialValue: String(repair.mileage))
        _cost = State(initialValue: String(repair.cost))
        _descriptionText = State(initialValue: repair.descriptionText ?? "")
        _date = State(initialValue: repair.date ?? Date())
    }

    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        Form {
            TextField("Przebieg", text: $mileage)
                .keyboardType(.numberPad)
            TextField("Koszt", text: $cost)
                .keyboardType(.decimalPad)
            Section(header: Text("Opis")) {
                TextEditor(text: $descriptionText)
                    .frame(height: 140)
            }
            
            Section(header: Text("Data")){
                DatePicker("Data", selection: $date, in: ...Date(), displayedComponents: .date)
                    .datePickerStyle(WheelDatePickerStyle())
                    .environment(\.locale, Locale(identifier: "pl_PL"))
            }
            

            Button("Zapisz zmiany") {
                let result = RepairValidator.validate(mileage: mileage, cost: cost, descriptionText: descriptionText)
                if result.0 {
                    repair.mileage = Int32(mileage) ?? 0
                    repair.cost = Double(cost) ?? 0.0
                    repair.descriptionText = descriptionText
                    repair.date = date

                    try? viewContext.save()
                    dismiss()
                } else {
                    alertMessage = result.1 ?? "Nieznany błąd"
                    showAlert = true
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Błąd"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .navigationTitle("Edytuj Naprawę")
    }
}



