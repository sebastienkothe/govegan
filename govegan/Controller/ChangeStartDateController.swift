//
//  ChangeStartDateController.swift
//  govegan
//
//  Created by Mosma on 11/08/2021.
//

import UIKit

class ChangeStartDateController: UIViewController {
    
    // MARK: - Internal methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let userID = authenticationService.getCurrentUser()?.uid else {
            navigationController?.popViewController(animated: true)
            UIAlertService.showAlert(style: .alert, title: "error".localized, message: "unable_to_retrieve_account_data".localized)
            return
        }
        
        currentUserID = userID
        
        getStartDate()
        veganTextField.setupTextField(datePicker: datePicker)
        
        datePicker.valuePickerHasBeenChanged = { [weak self] newDate in
            self?.veganTextField.text = self?.dateHandler.convertDateAsString(date: newDate)
        }
        
        veganTextField.previousYearButtonTapped = { [weak self] in
            guard let self = self else { return "" }
            return self.datePicker.setDateToPreviousYear()
        }
        
        veganTextField.currentDateButtonTapped = { [weak self] in
            guard let self = self else { return "" }
            return self.datePicker.setDateToCurrentDate()
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var veganStartDateLbl: UILabel!
    @IBOutlet weak var veganTextField: PickUpUserInfoTextField!
    
    // MARK: - IBActions
    @IBAction func backBtnTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendBtnTapped(_ sender: UIButton) {
        handleChangePasswordRequest()
    }
    
    // MARK: - Private properties
    private let firestoreManager = FirestoreManager()
    private let authenticationService = AuthenticationService()
    private let datePicker = VeganStartDatePicker()
    private let dateHandler = DateHandler()
    private var currentUserID = ""

    // MARK: - Private methods
    
    /// Handle the request to change user's password
    private func handleChangePasswordRequest() {
        
        let cancel = UIAlertAction(title: "cancel".localized, style: .cancel)
        let okay = UIAlertAction(title: "yes".localized, style: .destructive) { [weak self] _ in
            self?.updateVeganStartDate()
        }
        UIAlertService.showAlert(style: .alert, title: "change_date".localized, message: "change_date_confirmation".localized, actions: [okay, cancel], completion: nil)
    }
    
    /// Get the current vegan start date to change it later
    private func getStartDate() {
        firestoreManager.getValueFromDocument(userID: currentUserID, valueToReturn: .veganStartDateKey) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let anyObject):
                guard let veganStartDate = self.firestoreManager.convertTimestampObjectToDate(object: anyObject) else { return }
                guard let dateAsString = self.dateHandler.convertDateAsString(date: veganStartDate) else { return }
                self.veganStartDateLbl.text = dateAsString
                self.veganTextField.text = dateAsString
                
                self.datePicker.date = veganStartDate
            case .failure(let error):
                UIAlertService.showAlert(style: .alert, title: "error".localized, message: error.title)
            }
        }
    }
    
    /// Used to handle the request to change vegan start date
    private func updateVeganStartDate() {
        firestoreManager.updateADocument(userID: currentUserID, userData: [.veganStartDateKey : datePicker.date], completion: { [weak self] (result) in
            
            var successResult = false
            
            switch result {
            case .success: successResult = !successResult
                NotificationCenter.default.post(name: .veganStartDateHasBeenChanged, object: nil)
            case .failure: break
            }
            
            self?.navigationController?.popViewController(animated: true)
            UIAlertService.showAlert(style: .alert, title: nil, message: successResult ? "date_updated".localized : "date_updated_error".localized)
        })
    }
}
