

import Foundation
import CoreData


extension Car {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Car> {
        return NSFetchRequest<Car>(entityName: "Car")
    }

    @NSManaged public var brand: String?
    @NSManaged public var id: UUID?
    @NSManaged public var image: Data?
    @NSManaged public var model: String?
    @NSManaged public var vin: String?
    @NSManaged public var year: Int16
    @NSManaged public var repairs: NSSet?

}

// MARK: Generated accessors for repairs
extension Car {

    @objc(addRepairsObject:)
    @NSManaged public func addToRepairs(_ value: Repair)

    @objc(removeRepairsObject:)
    @NSManaged public func removeFromRepairs(_ value: Repair)

    @objc(addRepairs:)
    @NSManaged public func addToRepairs(_ values: NSSet)

    @objc(removeRepairs:)
    @NSManaged public func removeFromRepairs(_ values: NSSet)

}

extension Car : Identifiable {

}
