//
//  VeganStartDatePicker.swift
//  govegan
//
//  Created by Mosma on 12/08/2021.
//

import UIKit

class VeganStartDatePicker: UIDatePicker {
    
    // MARK: - Internal properties
    var valuePickerHasBeenChanged: ((Date) -> Void)?
    
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
        
        guard let dateAsString = dateHandler.convertDateAsString(date: date) else { return ""}
        return dateAsString
    }
    
    /// Used to define the date minus one year
    func setDateToPreviousYear() -> String {
        var dateComponent = DateComponents()
        dateComponent.year = -1
        
        guard let previousYear = Calendar.current.date(byAdding: dateComponent, to: date) else { return "" }
        date = previousYear
        
        guard let dateAsString = dateHandler.convertDateAsString(date: date) else { return ""}
        return dateAsString
    }
    
    // MARK: - Private properties
    private let dateHandler = DateHandler()
    
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
        valuePickerHasBeenChanged?(date)
    }
}
