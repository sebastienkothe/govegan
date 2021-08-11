//
//  DateService.swift
//  govegan
//
//  Created by Mosma on 11/08/2021.
//

import UIKit

class DateService {
    
    // MARK: - Internal methods
    
    /// Convert date to String with specific format
    func convertDateToStringFrom(_ datePicker: UIDatePicker) -> String? {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .short
        dateFormat.timeStyle = .short
        dateFormat.locale = Locale(identifier: "FR-fr")
        
        return dateFormat.string(from: datePicker.date)
    }
    
    func setDatePickerMinimumDate(_ datePicker: UIDatePicker) {
        var dateComponent = DateComponents()
        dateComponent.year = -100
        
        guard let currentDateMinusOneHundredYears = Calendar.current.date(byAdding: dateComponent, to: Date()) else { return }
        datePicker.minimumDate = currentDateMinusOneHundredYears
    }
}
