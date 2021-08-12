//
//  SettingViewController.swift
//  govegan
//
//  Created by Mosma on 30/05/2021.
//

import UIKit

class SettingViewController: UIViewController {
    
    // MARK: - Internal functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Used to handle the safely account deletion
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserDeletion), name: .accountCanBeDeletedSafely, object: nil)
    }
    
    // MARK: - IBActions
    @IBAction func settingButtonTapped(_ sender: UIButton) {
        if sender.tag == 0 {
            handleRequest(tag: sender.tag)
        } else if sender.tag == 1 {
            handleRequest(tag: sender.tag)
        } else if sender.tag == 2 {
            showStatistics()
        } else {
            
        }
    }
    
    // MARK: - Private properties
    private let firestoreManager = FirestoreManager.shared
    private let authenticationService = AuthenticationService()
    
    // MARK: - Private functions
    
    /// Displays the appropriate alert based on the button pressed
    private func handleRequest(tag: Int) {
        let cancel = UIAlertAction(title: "cancel".localized, style: .cancel)
        let okay = UIAlertAction(title: "yes".localized, style: tag == 1 ? .destructive : .default) { [weak self] _ in
            tag == 0 ? self?.handleDisconnection() : self?.handleUserDeletion()
        }
        
        let messages = ["disconnection_question", "delete_account_request"]
        UIAlertService.showAlert(style: .alert, title: nil, message: messages[tag].localized, actions: [okay, cancel], completion: nil)
    }
    
    /// Try to log out the user
    private func handleDisconnection() {
        authenticationService.disconnectUserFromApp { [weak self] result in
            
            switch result {
            case .failure(let error):
                UIAlertService.showAlert(style: .alert, title: "error".localized, message: error.title)
            case .success:
                self?.navigationController?.popToRootViewController(animated: true)
            }
         
           
        }
    }
    
    /// Call the appropriate method and display an error if necessary
    private func handleUserDeletionFromDatabase(userID: String?) {
        guard let userID = userID else { return }
        self.firestoreManager.deleteADocument(userID: userID, completion: { error in
            if let error = error {
                UIAlertService.showAlert(style: .alert, title: "error".localized, message: error.title)
            }
        })
    }
    
    
    /// Handles the display of potential errors returned by the deleteUserAuthentication method
    private func handleUserDeletionWith(_ error: AuthenticationServiceError) {
        if error == .logInBeforeDeletingTheAccount {
            self.performSegue(withIdentifier: .segueToLoginFromSetting, sender: nil)
            UIAlertService.showAlert(style: .alert, title: "security".localized, message: error.title)
        } else {
            UIAlertService.showAlert(style: .alert, title: "error".localized, message: error.title)
        }
    }
    
    /// Open the browser to display the site where the statistics come from
    private func showStatistics() {
        if let url = URL(string: .facts) {
            UIApplication.shared.open(url) { success in
                guard success else {
                    UIAlertService.showAlert(style: .alert, title: "error".localized, message: "unable_to_open_url".localized)
                    return
                }
            }
        }
    }
    
    /// Removes user authentication and data
    @objc private func handleUserDeletion() {
        let currentUserID = authenticationService.getCurrentUser()?.uid
        
        authenticationService.deleteUserAuthentication { [weak self] result in
            switch result {
            case .failure(let error):
                self?.handleUserDeletionWith(error)
                return
                
            case .success:
                self?.handleUserDeletionFromDatabase(userID: currentUserID)
                self?.navigationController?.popToRootViewController(animated: true)
                UIAlertService.showAlert(style: .alert, title: nil, message: "deleted_account".localized)
            }
        
            
        }
    }
}

// MARK: - Segue
extension SettingViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let loginViewController = segue.destination as? LoginViewController else { return }
        loginViewController.accountDeletionIsInitiated = true
    }
}
