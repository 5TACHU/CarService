

import Foundation
import CoreData


extension Repair {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Repair> {
        return NSFetchRequest<Repair>(entityName: "Repair")
    }

    @NSManaged public var cost: Double
    @NSManaged public var date: Date?
    @NSManaged public var descriptionText: String?
    @NSManaged public var id: UUID?
    @NSManaged public var isImportant: Bool
    @NSManaged public var mileage: Int32
    @NSManaged public var car: Car?

}

extension Repair : Identifiable {

}
