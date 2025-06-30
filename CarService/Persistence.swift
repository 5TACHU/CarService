import CoreData

struct PersistenceController { //menadżer core data
    static let shared = PersistenceController() //tworzenie jednej instancji

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "CarService") //tworzenie kontenera
        container.loadPersistentStores { _, error in   //ładowanie danych z dysku
            if let error = error {
                fatalError("Nie udało się załadować Core Data: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {  //główny kontekst
        return container.viewContext
    }
    
}



