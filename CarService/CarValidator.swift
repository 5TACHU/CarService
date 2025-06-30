import Foundation

struct CarValidator {
    
    static func validate(brand: String, model: String, vin: String) -> (Bool, String?) {
        guard !brand.isEmpty, !model.isEmpty, !vin.isEmpty else {
            return (false, "Wszystkie pola muszą być uzupełnione.")
        }

        let brandModelRegex = "^[A-Za-z0-9]+$"
        if (brand.range(of: brandModelRegex, options: .regularExpression) == nil) ||
            (model.range(of: brandModelRegex, options: .regularExpression) == nil) {
            return (false, "Marka i model mogą zawierać tylko litery i cyfry.")
        }

        let vinRegex = "^[A-HJ-NPR-Z0-9]{17}$"
        if vin.range(of: vinRegex, options: .regularExpression) == nil {
            return (false, "VIN musi mieć dokładnie 17 znaków i nie może zawierać liter Q, O, I.")
        }

        return (true, nil)
    }
}

