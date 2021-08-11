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
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var screenTitleLbl: UILabel!
    
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
        
        if shouldResetPassword {
            authenticationService.resetPassword(email: email) { result in
                switch result {
                
                case .success:
                    UIAlertService.showAlert(style: .alert, title: nil, message: "check_your_mailbox".localized)
                    self.handlePasswordRecoveryRequest()
                    
                case .failure(let error):
                    UIAlertService.showAlert(style: .alert, title: "error".localized, message: error.title)
                }
            }
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
    
    @IBAction func resetPasswordBtnTapped() {
        handlePasswordRecoveryRequest()
    }
    
    
    // MARK: - Private properties
    private let authenticationService = AuthenticationService()
    private var shouldResetPassword = false
    
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
    
    /// Handle activation and setup the password text field
    private func handlePasswordRecoveryRequest() {
        shouldResetPassword = !shouldResetPassword
        passwordTextField.isEnabled = !passwordTextField.isEnabled
        
        if shouldResetPassword {
            UIAlertService.showAlert(style: .alert, title: nil, message: "request_user_mail_password_reset".localized)
            screenTitleLbl.text = "account_recovery".localized
            forgotPasswordBtn.setTitle("log_in".localized, for: .normal)
        } else {
            screenTitleLbl.text = "connection".localized
            forgotPasswordBtn.setTitle("forgot_your_password".localized, for: .normal)
        }
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}
