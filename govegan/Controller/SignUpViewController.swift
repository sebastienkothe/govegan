//
//  SignUpViewController.swift
//  govegan
//
//  Created by Mosma on 06/06/2021.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    // MARK: - Internal properties
    
    /// Contains manually entered user data
    var userData: [String]?
    
    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - IBActions
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func registerButtonTapped() {
        guard let email = emailTextField.text, email.trimmingCharacters(in: .whitespaces) != "" else {
            UIAlertService.showAlert(style: .alert, title: "mail_required".localized, message: "request_user_mail".localized)
            return
        }
        
        guard let password = passwordTextField.text,
              password.trimmingCharacters(in: .whitespaces) != "" else {
            UIAlertService.showAlert(style: .alert, title: "password_required".localized, message: "request_user_password".localized)
            return
        }
        
        handleAccountCreationWith(email, and: password)
    }
    
    @IBAction func homeButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Private properties
    private let firestoreManager = FirestoreManager.shared
    private let authenticationService = AuthenticationService()
    
    // MARK: - Private functions
    
    /// Used to create an account
    private func handleAccountCreationWith(_ email: String, and password: String) {
        let cancel = UIAlertAction(title: "cancel".localized, style: .cancel)
        let okay = UIAlertAction(title: "continue".localized, style: .default) { [weak self] _ in
            
            self?.authenticationService.createAccountFrom(email, password, completion: { [weak self] result in
                    switch result {
                    case .success(let authDataResult):
                        self?.handleDatabaseRegistration(userID: authDataResult?.user.uid, email: email, password: password)
                    case .failure(let error):
                        UIAlertService.showAlert(style: .alert, title: "error".localized, message: error.title)
                    }
                })
        }
        
        UIAlertService.showAlert(style: .alert, title: "create_account".localized, message: "ask_user_to_create_an_account".localized, actions: [okay, cancel], completion: nil)
    }
    
    /// Used to add user to the database
    private func handleDatabaseRegistration(userID: String?, email: String, password: String) {
        guard let username = self.userData?[0], let veganStartDate = self.userData?[1], let userID = userID else {
            return
        }
        
        let data: [String: String] = [.usernameKey : username, .veganStartDateKey: veganStartDate, .emailKey: email]
        
        firestoreManager.addDocumentWith(userID: userID, userData: data, completion: { [weak self] (result) in
            
            switch result {
            case .success:
                self?.performSegue(withIdentifier: .segueToTabBarFromSignUp, sender: nil)
            case .failure(let error):
                UIAlertService.showAlert(style: .alert, title: "error".localized, message: error.title)
            }
        })
    }
}


// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}
