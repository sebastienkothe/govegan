//
//  LogInViewController.swift
//  govegan
//
//  Created by Mosma on 13/05/2021.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Internal properties
    var accountDeletionIsInitiated = false
    
    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - IBActions
    
    /// Used to close the keyboard when the user taps the screen
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    /// Handle email/password connection
    @IBAction func didTapOnLoginButton(_ sender: UIButton) {
        guard let email = emailTextField.text, email.trimmingCharacters(in: .whitespaces) != "" else {
            UIAlertService.showAlert(style: .alert, title: "mail_required".localized, message: "request_user_mail".localized)
            return
        }
        
        guard let password = passwordTextField.text,
              password.trimmingCharacters(in: .whitespaces) != "" else {
            UIAlertService.showAlert(style: .alert, title: "password_required".localized, message: "request_user_password".localized)
            return
        }
        
        handleUserConnection(email: email, password: password)
    }
    
    @IBAction func backButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Private properties
    private let authenticationService = AuthenticationService()
    
    // MARK: - Private functions
    
    /// Try to log in the user
    private func handleUserConnection(email: String, password: String) {
        authenticationService.connectUserWith(email, and: password, completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            
            case .success:
                guard !self.accountDeletionIsInitiated else {
                    self.accountDeletionIsInitiated = false
                    NotificationCenter.default.post(name: .accountCanBeDeletedSafely, object: nil)
                    return
                }
                
                self.performSegue(withIdentifier: .segueToTabBarFromLogin, sender: nil)
                
            case .failure(let error):
                UIAlertService.showAlert(style: .alert, title: "error".localized, message: error.title)
                
            }
            
        })
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}
