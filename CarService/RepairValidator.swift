import Foundation

struct RepairValidator {
    static func validate(mileage: String, cost: String, descriptionText: String) -> (Bool, String?) {
        guard !mileage.isEmpty, !cost.isEmpty, !descriptionText.isEmpty else {
            return (false, "Wszystkie pola muszą być uzupełnione.")
        }
        
        let mileageRegex = "^[0-9]{1,7}$"
        if (mileage.range(of: mileageRegex, options: .regularExpression) == nil) {
            return (false, "Przebieg nieprawidłowy musi być w zakresie 0-9999999")
        }
        
        let costRegex = "^[0-9]{1,6}([.][0-9]{1,2})?$"
        if (cost.range(of: costRegex, options: .regularExpression) == nil) {
            return (false, "Koszt nieprawidłowy musi być w zakresie 0.00-999999.99")
        }
        return (true, nil)
    }
}

