//
//  PickUpUserInformationView.swift
//  govegan
//
//  Created by Mosma on 18/05/2021.
//

import Foundation
import UIKit

class PickUpUserInformationView: UIView {
    
    // MARK: - Internal functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Activates the text Field selection
        answerTextField.becomeFirstResponder()
    }
    
    // Load the .xib and add the content view to the view hierarchy
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    // MARK: - IBOutlets
    @IBOutlet var contentView: UIView!
    
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var answerTextField: UITextField!
    @IBOutlet private weak var proceedButton: NextButton!
    @IBOutlet weak var solidLineLabel: UILabel!
    
    // MARK: - IBActions
    @IBAction func didTapOnProceedButton() {
        onMainButtonTapped?()
    }
    
    var onMainButtonTapped: (() -> Void)?
    
    // MARK: - Private properties
    private let datePicker = UIDatePicker()

    // MARK: - Private functions
    private func initSubviews() {
        
        // Standard initialization logic
        let nib = UINib(nibName: "PickUpUserInformationView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    func createDatePickerView() {
        
        setupDatePicker()
        
        // Assign toolbar
        answerTextField.inputAccessoryView = generateToolbar()
        
        answerTextField.text = formatDate(datePicker: datePicker)
        
        // Assign date picker to the text field
        answerTextField.inputView = datePicker
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(dateChanged), for: .allEvents)
        datePicker.maximumDate = Date()
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func generateToolbar() -> UIToolbar {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        // Resizes the toolBar to use the most appropriate amount of space
        toolBar.sizeToFit()
        
        let previousYearButton = UIBarButtonItem(title: "Previous year", style: .done, target: self, action: #selector(didTapOnPreviousYearButton))
        let currentDate = UIBarButtonItem(title: "Now", style: .done, target: self, action: #selector(didTapOnCurrentDateButton))
        
        // Used to generate a space between the two main buttons
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([previousYearButton, spaceButton, currentDate], animated: true)
        
        toolBar.items?.forEach { (button) in
            button.tintColor = #colorLiteral(red: 0, green: 0.7733597755, blue: 0.4907547235, alpha: 1)
        }
        
        return toolBar
    }
    
    private func formatDate(datePicker: UIDatePicker) -> String? {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        
        return dateFormat.string(from: datePicker.date)
    }
    
    @objc private func dateChanged() {
        answerTextField.text = formatDate(datePicker: datePicker)
    }
    
    @objc private func didTapOnPreviousYearButton() {
        var dateComponent = DateComponents()
        dateComponent.year = -1
        
        guard let previousYear = Calendar.current.date(byAdding: dateComponent, to: datePicker.date) else { return }
        datePicker.date = previousYear
        answerTextField.text = formatDate(datePicker: datePicker)
    }
    
    @objc private func didTapOnCurrentDateButton() {
        datePicker.date = Date()
        answerTextField.text = formatDate(datePicker: datePicker)
    }
    
    
}

// MARK: - Keyboard
extension PickUpUserInformationView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        answerTextField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 13
        return range.location < maxLength
    }
}
