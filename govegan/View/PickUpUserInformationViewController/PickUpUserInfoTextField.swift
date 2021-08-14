//
//  PickUpUserInfoTextField.swift
//  govegan
//
//  Created by Mosma on 12/08/2021.
//

import UIKit

class PickUpUserInfoTextField: UITextField {
    
    // MARK: - Internal properties
    var previousYearButtonTapped: (() -> (String))?
    var currentDateButtonTapped: (() -> (String))?
    
    // MARK: - Internal methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Avoids a constraint problem when the keyboard is open and the application is in the background
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        // Activates the text Field selection
        becomeFirstResponder()
    }
    
    /// Adding a toolbar and date picker to the text field input view
    func setupTextField(datePicker: VeganStartDatePicker) {
        
        // Assign toolbar
        inputAccessoryView = generateToolbar()
        
        text = dateHandler.convertDateAsString(date: datePicker.date)
        
        // Assign date picker to the text field
        inputView = datePicker
        
        reloadInputViews()
    }
    
    /// Go back to the original interface configuration
    func returnToTheInitialConfigurationInterface() {
        inputAccessoryView = nil
        inputView = nil
        reloadInputViews()
        
        text = ""
    }
    
    // MARK: - Private properties
    private let dateHandler = DateHandler()
    
    // MARK: - Private methods
    private func generateToolbar() -> UIToolbar {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        // Resizes the toolBar to use the most appropriate amount of space
        toolBar.sizeToFit()
        
        let previousYearButton = UIBarButtonItem(title: "previous_year".localized, style: .done, target: self, action: #selector(didTapOnPreviousYearButton))
        let currentDate = UIBarButtonItem(title: "now".localized, style: .done, target: self, action: #selector(didTapOnCurrentDateButton))
        
        // Used to generate a space between the two main buttons
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([previousYearButton, spaceButton, currentDate], animated: true)
        
        toolBar.items?.forEach { (button) in
            button.tintColor = #colorLiteral(red: 0, green: 0.7733597755, blue: 0.4907547235, alpha: 1)
        }
        
        return toolBar
    }
    
    /// Close the keyboard when the application is in the background
    @objc private func appDidEnterBackground() {
        resignFirstResponder()
    }
    
    /// Notifies the object using the property that the user pressed the previous year button
    @objc private func didTapOnPreviousYearButton() {
        text = previousYearButtonTapped?()
    }
    
    /// Notifies the object using the property that the user pressed the current date button
    @objc private func didTapOnCurrentDateButton() {
        text = currentDateButtonTapped?()
    }
}
