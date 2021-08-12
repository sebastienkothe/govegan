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
        
        datePicker.valuePickerHasBeenChanged = { [weak self] newDate in
            self?.answerTextField.text = newDate
        }
        
        answerTextField.previousYearButtonTapped = { [weak self] in
            guard let self = self else { return "" }
            return self.datePicker.setDateToPreviousYear()
        }
        
        answerTextField.currentDateButtonTapped = { [weak self] in
            guard let self = self else { return "" }
            return self.datePicker.setDateToCurrentDate()
        }
        
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
    @IBOutlet private weak var answerTextField: PickUpUserInfoTextField!
    @IBOutlet private weak var proceedButton: NextButton!
    @IBOutlet private weak var solidLineLabel: UILabel!
    @IBOutlet private weak var backButton: UIButton!
    
    // MARK: - IBActions
    @IBAction private func didTapOnProceedButton() {
        guard let textFromAnswerTextField = answerTextField.text else { return }
        
        storeUserData(textFromAnswerTextField)
        
        if hasAllTheData {
            onMainButtonTapped?([name, veganStartDate])
            return
        }
        
        questionLabel.text = "vegan_start_date_question".localized
        
        answerTextField.setupTextField(datePicker: datePicker)
    }
        
    @IBAction private func didTapOnBackButton() {
        if questionLabel.text == "vegan_start_date_question".localized {
            questionLabel.text = "what_is_your_name_question".localized
            answerTextField.returnToTheInitialConfigurationInterface()
            handleProceedButton(mustBeActivated: false)
        } else {
            backButtonTapped?()
        }
    }
    
    // MARK: - Private properties
    private let datePicker = VeganStartDatePicker()
    
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
        proceedButton.backgroundColor = mustBeActivated ? #colorLiteral(red: 0, green: 0.6649529934, blue: 0.2719822228, alpha: 1) : #colorLiteral(red: 0.9025184512, green: 0.8971535563, blue: 0.9066424966, alpha: 1)
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
