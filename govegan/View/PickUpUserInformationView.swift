//
//  PickUpUserInformationView.swift
//  govegan
//
//  Created by Mosma on 18/05/2021.
//

import Foundation
import UIKit

class PickUpUserInformationView: UIView {
    
    // MARK: - Internal properties
    var onMainButtonTapped: (() -> Void)?
    var backButtonTapped: (() -> Void)?
    
    // MARK: - Internal functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureTheTextsOfTheViews()
        
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
    @IBOutlet private var contentView: UIView!
    
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var answerTextField: UITextField!
    @IBOutlet private weak var proceedButton: NextButton!
    @IBOutlet private weak var solidLineLabel: UILabel!
    @IBOutlet private weak var backButton: UIButton!
    
    // MARK: - IBActions
    @IBAction private func didTapOnProceedButton() {
        questionLabel.text = "vegan_start_date_question".localized
        
        if questionLabel.text == "vegan_start_date_question".localized {
            createDatePickerView()
            answerTextField.reloadInputViews()
        }
        
        onMainButtonTapped?()
    }
    
    @IBAction private func didTapOnBackButton() {
        if questionLabel.text == "vegan_start_date_question".localized {
            questionLabel.text = "what_is_your_name_question".localized
            answerTextField.inputAccessoryView = nil
            answerTextField.inputView = nil
            
            answerTextField.reloadInputViews()
            
            answerTextField.text = ""
        } else {
            backButtonTapped?()
        }
    }
    
    // MARK: - Private properties
    private let datePicker = UIDatePicker()
    
    // MARK: - Private functions
    
    /// Configure the texts to be displayed in the views
    private func configureTheTextsOfTheViews() {
        questionLabel.text = "what_is_your_name_question".localized
        proceedButton.setTitle("proceed".localized, for: .normal)
        backButton.setTitle("back_button".localized, for: .normal) 
    }
    
    private func initSubviews() {
        
        // Standard initialization logic
        let nib = UINib(nibName: .pickUpUserInformationView, bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
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
    
    private func formatDate(datePicker: UIDatePicker) -> String? {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        
        return dateFormat.string(from: datePicker.date)
    }
    
    private func createDatePickerView() {
        
        setupDatePicker()
        
        // Assign toolbar
        answerTextField.inputAccessoryView = generateToolbar()
        
        answerTextField.text = formatDate(datePicker: datePicker)
        
        // Assign date picker to the text field
        answerTextField.inputView = datePicker
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

extension PickUpUserInformationView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        answerTextField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 13
        return range.location < maxLength
    }
}
