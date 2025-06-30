import SwiftUI

@main
struct CarServiceApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            CarListView()
                .environment(\.managedObjectContext, persistenceController.context)
        }
    }
}


