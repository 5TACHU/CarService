import SwiftUI
import CoreData

struct RepairListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var car: Car //car przyszedł jako argument

    @FetchRequest private var repairs: FetchedResults<Repair> //pobranie napraw z core data
    @State private var isAddingRepair = false
    
    //wczytanie napraw dla konkretnego auta
    init(car: Car) {
        self.car = car
        _repairs = FetchRequest(entity: Repair.entity(), sortDescriptors: [], predicate: NSPredicate(format: "car == %@", car))
    }//"car == %@" car to wlasciwosc w encji Repair   %@ znak zastepczy    a car argument to przyszedł z CarListView
    //_repairs oryginalna zmienna(można modyfikować)

    @State private var selectedRepair: Repair?
    
    var body: some View {
        List {
            ForEach(repairs) { repair in
                VStack(alignment: .leading) {
                    Text("Przebieg: \(String(repair.mileage)) km")
                    Text("Koszt: \(String(format: "%.2f", Double(repair.cost))) zł")
                    Text(repair.descriptionText ?? "Brak opisu")
                    Text("Data: \(repair.date ?? Date(), style: .date)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .environment(\.locale, Locale(identifier: "pl_PL"))
                }
                .padding()
                .cornerRadius(8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(repair.isImportant ? Color.yellow : Color.clear)
                .onTapGesture(count: 2) { //podwójne dotknięcie
                    changeImportant(repair)
                }
                .onLongPressGesture { //długie przytrzymanie
                    selectedRepair = repair
                }
            }.onDelete(perform: deleteRepair)
             .sheet(item: $selectedRepair) { repair in
                EditRepairView(repair: repair)
            }
        }
        .navigationTitle("Naprawy \(car.brand ?? "") \(car.model ?? "")")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { isAddingRepair = true }) {
                    Label("Dodaj Naprawę", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $isAddingRepair) {
            AddRepairView(car: car)
        }
    }
    
    private func deleteRepair(at offsets: IndexSet) {
        for index in offsets {
            let repair = repairs[index]
            viewContext.delete(repair)
        }
        try? viewContext.save()
    }
    
    private func changeImportant(_ repair: Repair) {
        repair.isImportant.toggle()
        try? viewContext.save()
    }
}
