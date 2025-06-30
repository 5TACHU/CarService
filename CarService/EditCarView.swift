import SwiftUI
import PhotosUI

struct EditCarView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var car: Car //oryginalny obiekt z bazy
    @State private var brand: String
    @State private var model: String
    @State private var year: Int
    @State private var vin: String


    init(car: Car) {
        self.car = car
        _brand = State(initialValue: car.brand ?? "")
        _model = State(initialValue: car.model ?? "")
        _year = State(initialValue: Int(car.year))
        _vin = State(initialValue: car.vin ?? "")
    }

    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        Form {
            TextField("Marka", text: $brand)
            TextField("Model", text: $model)
            Stepper("Rok produkcji: \(String(format:"%d" ,year))", value: $year, in: 1900...2025)
            TextField("VIN(dużymi literami)", text: $vin)

        
            // jeśli wybrane to pokaż  wybrane zdjęcie
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(10)
            }
            // jeśli nie wybrane, pokaż zdjęcie z Core Data
            else if let imageData = car.image, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(10)
            }

            
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()
            ){
                Label("Wybierz zdjęcie", systemImage: "photo")
            }
            .onChange(of: selectedItem) {
                Task {
                    if let data = try? await selectedItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        selectedImage = uiImage
                    }
                }
            }
            
            
            Button("Zapisz zmiany") {
                let result = CarValidator.validate(brand: brand, model: model, vin: vin)
                if result.0 {
                    car.brand = brand
                    car.model = model
                    car.year = Int16(year)
                    car.vin = vin
                    
                    // Konwersja UIImage na Data i zapis do Core Data
                    if let selectedImage = selectedImage, let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
                        car.image = imageData
                    }
                    
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
        .navigationTitle("Edytuj Auto")
    }
}
