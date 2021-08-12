//
//  VeganStartDatePicker.swift
//  govegan
//
//  Created by Mosma on 12/08/2021.
//

import UIKit

class VeganStartDatePicker: UIDatePicker {
    
    // MARK: - Internal properties
    var valuePickerHasBeenChanged: ((String) -> Void)?
    
    // MARK: - Internal methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    /// Used to handle the user's interaction with currentDateButton
    func setDateToCurrentDate() -> String {
        maximumDate = Date()
        date = Date()
        return convertDateToString()
    }
    
    /// Used to define the date minus one year
    func setDateToPreviousYear() -> String {
        var dateComponent = DateComponents()
        dateComponent.year = -1
        
        guard let previousYear = Calendar.current.date(byAdding: dateComponent, to: date) else { return "" }
        date = previousYear
        return convertDateToString()
    }
    
    /// Convert date to String with specific format
    func convertDateToString() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .short
        dateFormat.timeStyle = .short
        dateFormat.locale = Locale(identifier: "FR-fr")
        
        return dateFormat.string(from: date)
    }
    
    // MARK: - Private methods
    
    /// Initial setup
    private func setup() {
        datePickerMode = .dateAndTime
        maximumDate = Date()
        setDatePickerMinimumDate()
        
        if #available(iOS 13.4, *) {
            preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        addTarget(self, action: #selector(dateChanged), for: .allEvents)
    }
    
    /// Used to set the minimum picker date
    private func setDatePickerMinimumDate() {
        var dateComponent = DateComponents()
        dateComponent.year = -100
        
        guard let currentDateMinusOneHundredYears = Calendar.current.date(byAdding: dateComponent, to: Date()) else { return }
        minimumDate = currentDateMinusOneHundredYears
    }
    
    
    /// Called when the value changes
    @objc private func dateChanged() {
        valuePickerHasBeenChanged?(convertDateToString())
    }
}
