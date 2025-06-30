import SwiftUI
import CoreData

struct AddRepairView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    var car: Car //car przyszedł jako argument
    @State private var mileage = ""
    @State private var cost = ""
    @State private var descriptionText = ""
    @State private var date = Date()
    @State private var isImportant: Bool = false
    
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        Form {
            TextField("Przebieg auta", text: $mileage)
                .keyboardType(.numberPad)
            
            TextField("Koszt", text: $cost)
                .keyboardType(.decimalPad)
            
            Section(header: Text("Opis")) {
                TextEditor(text: $descriptionText)
                    .frame(height: 140)
            }
            
            Toggle("Oznacz jako ważna", isOn: $isImportant)
            
            Section(header: Text("Data")){
                DatePicker("Data", selection: $date, in: ...Date(), displayedComponents: .date)
                    .datePickerStyle(WheelDatePickerStyle())
                    .environment(\.locale, Locale(identifier: "pl_PL"))
            }
            
            Button("Dodaj naprawę") {
                if validateInput(){
                    addRepair()
                }
                else{
                    showAlert = true
                }
            }
        }
        .alert(isPresented: $showAlert){
            Alert(title: Text("Błąd"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    private func validateInput() -> Bool {
        let result = RepairValidator.validate(mileage: mileage, cost: cost, descriptionText: descriptionText)
        if !result.0 {
            alertMessage = result.1 ?? "Nieznany błąd"
        }
        return result.0
    }
    
    private func addRepair() {
        let newRepair = Repair(context: viewContext)
        newRepair.id = UUID()
        newRepair.mileage = Int32(mileage) ?? 0
        newRepair.cost = Double(cost) ?? 0.0
        newRepair.descriptionText = descriptionText
        newRepair.isImportant = isImportant
        newRepair.date = date
        newRepair.car = car

        try? viewContext.save()
        dismiss()
    }
}
