import SwiftUI
import PhotosUI

struct AddCarView: View {
    //@Environment daj dostep do wartości wbudowanych w srodowisko
    @Environment(\.managedObjectContext) private var viewContext //referencja do Core Data(dzięki temu można zapisywać, usuwać i edytować dane w bazie)
    @Environment(\.dismiss) private var dismiss //pozwoli zamknąć aktualny widok

    @State private var brand = ""
    @State private var model = ""
    @State private var year = 2024
    @State private var vin = ""
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Marka", text: $brand)
                TextField("Model", text: $model)
                TextField("VIN(dużymi literami)", text: $vin)
                Stepper("Rok produkcji: \(String(format:"%d" ,year))", value: $year, in: 1900...2025)

                // Podgląd zdjęcia auta
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(10)
                }
                
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,  //tylko obrazy
                    photoLibrary: .shared()
                ){
                    Label("Wybierz zdjęcie", systemImage: "photo")
                }
                .onChange(of: selectedItem) { //kiedy zostało wybrane zdjęcie
                    Task { //tworzy zadanie asynchroniczne
                        // pobiera wybrane zdjęcie jako Data (try?-nil jeśli cos pojdzie nie tak, await-czekaj, jak funkcja się skonczy idz dalej)
                        if let data = try? await selectedItem?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            selectedImage = uiImage
                        }
                    }
                }

                Button("Dodaj auto") {
                    if validateInput() {
                        addCar()
                    }
                    else{
                        showAlert = true
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Błąd"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .navigationTitle("Dodaj auto")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Anuluj") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func validateInput() -> Bool {
        let result = CarValidator.validate(brand: brand, model: model, vin: vin)
        if !result.0 {
            alertMessage = result.1 ?? "Nieznany błąd"
        }
        return result.0
    }
    
    private func addCar() {
        let newCar = Car(context: viewContext)
        newCar.id = UUID()
        newCar.brand = brand
        newCar.model = model
        newCar.year = Int16(year)
        newCar.vin = vin

        // Konwersja UIImage na Data i zapis do Core Data
        if let selectedImage = selectedImage, let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
            newCar.image = imageData
        }
        
        try? viewContext.save()
        dismiss()
    }
    
    
}
