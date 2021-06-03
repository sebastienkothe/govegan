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
    var onMainButtonTapped: (([String]) -> Void)?
    var backButtonTapped: (() -> Void)?
    
    // MARK: - Internal functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
                
        // Avoids a constraint problem when the keyboard is open and the application is in the background
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
       
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
        guard let textFromAnswerTextField = answerTextField.text else { return }
        
        storeUserData(textFromAnswerTextField)
        
        guard !hasAllTheData else {
            onMainButtonTapped?([name, veganStartDate])
            return
        }
        
        questionLabel.text = "vegan_start_date_question".localized
        
        createDatePickerView()
    }
        
    @IBAction private func didTapOnBackButton() {
        if questionLabel.text == "vegan_start_date_question".localized {
            returnToTheInitialConfigurationInterface()
            handleProceedButton(mustBeActivated: false)
        } else {
            backButtonTapped?()
        }
    }
    
    // MARK: - Private properties
    private let datePicker = UIDatePicker()
    
    private var name = ""
    private var veganStartDate: String = "" {
        didSet {
            if name != "".trimmingCharacters(in: .whitespaces) {
                hasAllTheData = true
            }
        }
    }
    
    private var hasAllTheData = false
    
    // MARK: - Private functions
    
    /// Retrieves user data
    private func storeUserData(_ textFromAnswerTextField: String) {
        if questionLabel.text == "vegan_start_date_question".localized {
            veganStartDate = textFromAnswerTextField
        } else {
            name = textFromAnswerTextField
        }
    }
    
    /// Used to hide/show items
    private func handleProceedButton(mustBeActivated: Bool) {
        
        proceedButton.isUserInteractionEnabled = mustBeActivated ? true : false
        
        if mustBeActivated {
            proceedButton.backgroundColor = #colorLiteral(red: 0, green: 0.6649529934, blue: 0.2719822228, alpha: 1)
        } else {
            proceedButton.backgroundColor = #colorLiteral(red: 0.9025184512, green: 0.8971535563, blue: 0.9066424966, alpha: 1)
        }
        
    }
    
    /// Go back to the original interface configuration
    private func returnToTheInitialConfigurationInterface() {
        questionLabel.text = "what_is_your_name_question".localized
        
        answerTextField.inputAccessoryView = nil
        answerTextField.inputView = nil
        answerTextField.reloadInputViews()
        
        answerTextField.text = ""
    }
    
    /// Configure the texts to be displayed in the views
    private func setupViews() {
        questionLabel.text = "what_is_your_name_question".localized
        proceedButton.setTitle("proceed".localized, for: .normal)
        backButton.setTitle("back_button".localized, for: .normal)
        handleProceedButton(mustBeActivated: false)
    }
    
    private func initSubviews() {
        
        // Standard initialization logic
        let nib = UINib(nibName: .pickUpUserInformationView, bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        
        addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        questionLabel.numberOfLines = 0
    }
    
    /// Configure the previously initialized datePicker
    private func setupDatePicker() {
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(dateChanged), for: .allEvents)
        datePicker.maximumDate = Date()
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        var dateComponent = DateComponents()
        dateComponent.year = -100
        
        guard let currentDateMinusOneHundredYears = Calendar.current.date(byAdding: dateComponent, to: Date()) else { return }
        print(currentDateMinusOneHundredYears)
        datePicker.minimumDate = currentDateMinusOneHundredYears
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
    
    /// Convert datePicker.date to String with specific format
    private func convertDateToStringFrom(_ datePicker: UIDatePicker) -> String? {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .short
        dateFormat.timeStyle = .short
        dateFormat.locale = Locale(identifier: "FR-fr")
        
        return dateFormat.string(from: datePicker.date)
    }
    
    private func createDatePickerView() {
        
        setupDatePicker()
        
        // Assign toolbar
        answerTextField.inputAccessoryView = generateToolbar()
        
        answerTextField.text = convertDateToStringFrom(datePicker)
        
        // Assign date picker to the text field
        answerTextField.inputView = datePicker
        
        answerTextField.reloadInputViews()
    }
    
    @objc private func dateChanged() {
        answerTextField.text = convertDateToStringFrom(datePicker)
    }
    
    @objc private func didTapOnPreviousYearButton() {
        var dateComponent = DateComponents()
        dateComponent.year = -1
        
        guard let previousYear = Calendar.current.date(byAdding: dateComponent, to: datePicker.date) else { return }
        datePicker.date = previousYear
        answerTextField.text = convertDateToStringFrom(datePicker)
    }
    
    @objc private func didTapOnCurrentDateButton() {
        datePicker.maximumDate = Date()
        datePicker.date = Date()
        answerTextField.text = convertDateToStringFrom(datePicker)
    }
    
    @objc private func appDidEnterBackground() {
        answerTextField.resignFirstResponder()
    }
    
}

extension PickUpUserInformationView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        answerTextField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 13
        let minLength = 2
        
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        !text.trimmingCharacters(in: .whitespaces).isEmpty && text.count >= minLength ? handleProceedButton(mustBeActivated: true) : handleProceedButton(mustBeActivated: false)
        
        return range.location < maxLength
    }
}