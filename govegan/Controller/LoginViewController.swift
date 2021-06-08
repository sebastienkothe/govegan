//
//  LogInViewController.swift
//  govegan
//
//  Created by Mosma on 13/05/2021.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    // MARK: - Internal properties
    
    // MARK: - Internal functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
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
        
        connectUserWith(email, password)
    }
    
    @IBAction func backButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Private properties
    
    // MARK: - Private functions
    
    /// Allows the user to connect with his email address and password
    private func connectUserWith(_ email: String, _ password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
            guard error == nil else {
                guard let error = error else { return }
                UIAlertService.showAlert(style: .alert, title: "error".localized, message: error.localizedDescription)
                return
            }
            
            self?.performSegue(withIdentifier: .segueToTabBarFromLogin, sender: nil)
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}
