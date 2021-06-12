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
    
    // MARK: - Internal functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
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
        
        createAccountFrom(email, password)
    }
    
    @IBAction func homeButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Private properties
    private let firestoreManager = FirestoreManager.shared
    
    // MARK: - Private functions
    
    /// Used to create an account
    private func createAccountFrom(_ email: String, _ password: String) {
        let cancel = UIAlertAction(title: "cancel".localized, style: .cancel)
        let okay = UIAlertAction(title: "continue".localized, style: .default) { [weak self] _ in
            
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
                
                // Handle the error
                if let error = error {
                    UIAlertService.showAlert(style: .alert, title: "error".localized, message: error.localizedDescription)
                }
                
                
                guard let username = self?.userData?[0], let veganStartDate = self?.userData?[1], let userID = result?.user.uid else {
                    return
                }
                
                self?.firestoreManager.addDocumentWith(userID: userID, username: username, veganStartDate: veganStartDate, email: email, completion: { [weak self] (result) in
                    
                    switch result {
                    case .success:
                        self?.performSegue(withIdentifier: .segueToTabBarFromSignUp, sender: nil)
                    case .failure(let error):
                        UIAlertService.showAlert(style: .alert, title: "error".localized, message: error.title)
                    }
                })
            }
        }
        
        UIAlertService.showAlert(style: .alert, title: "create_account".localized, message: "ask_user_to_create_an_account".localized, actions: [okay, cancel], completion: nil)
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}
