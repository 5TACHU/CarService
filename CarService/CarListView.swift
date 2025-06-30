import SwiftUI
import CoreData

struct CarListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var cars: FetchedResults<Car>
    //FetchRequest pobiera wszystkie auta z Core Data
    //sortDescriptors: [] brak sortowania
    //FetchedResults<Car> struktura podobna do tablicy (Array)
    
    @State private var isAddingCar = false

    @State private var size = false
    
    @State private var selectedCar: Car?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(cars) { car in
                    NavigationLink(destination: RepairListView(car: car)) {
                        HStack {
                            if let imageData = car.image, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: size ? 300 : 100, height: size ? 300 : 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .onTapGesture { //dotknięcie zdjęcia
                                        size.toggle()
                                    }
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 100, height: 100)
                            }
                            VStack(alignment: .leading) {
                                Text("\(car.brand ?? "Brak") \(car.model ?? "Brak")")
                                    .font(.headline)
                                Text("Rok produkcji: \(String(format:"%d", car.year))")
                                    .font(.subheadline)
                                Text("Numer VIN: \(car.vin ?? "Brak")")
                                    .font(.subheadline)
                            }
                        }.frame(maxWidth: 300, maxHeight: 300, alignment: .leading)
                            .onLongPressGesture { //długie przytrzymanie
                                selectedCar = car
                            }
                    }
                }
                .onDelete(perform: deleteCar)
                .sheet(item: $selectedCar) { car in
                    EditCarView(car: car)
                }
               
            }// end list
            .navigationTitle("MOJE AUTA")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isAddingCar = true }) {
                        Label("Dodaj Auto", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddingCar) {
                AddCarView()
            }
        }
    }

    private func deleteCar(at offsets: IndexSet) {
        for index in offsets {
            let car = cars[index]
            viewContext.delete(car)
        }
        try? viewContext.save()
    }
}


