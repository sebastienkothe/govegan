//
//  SettingViewController.swift
//  govegan
//
//  Created by Mosma on 30/05/2021.
//

import UIKit

class SettingViewController: UIViewController {
    
    // MARK: - IBActions
    @IBAction func settingButtonTapped(_ sender: UIButton) {
        if sender.tag == 0 {
            handleRequest(tag: sender.tag)
        } else if sender.tag == 1 {
            handleRequest(tag: sender.tag)
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
        let okay = UIAlertAction(title: "yes".localized, style: .default) { [weak self] _ in
            tag == 0 ? self?.handleDisconnection() : self?.handleUserDeletion()
        }
        
        let messages = ["disconnection_question", "delete_account_request"]
        UIAlertService.showAlert(style: .alert, title: nil, message: messages[tag].localized, actions: [okay, cancel], completion: nil)
    }
    
    private func handleDisconnection() {
        authenticationService.disconnectUserFromApp { [weak self] error in
            
            if let error = error {
                UIAlertService.showAlert(style: .alert, title: "error".localized, message: error.title)
                return
            }
            
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    private func handleUserDeletionWith(_ error: AuthenticationServiceError) {
        if error == .logInBeforeDeletingTheAccount {
            self.performSegue(withIdentifier: .segueToLoginFromSetting, sender: nil)
            UIAlertService.showAlert(style: .alert, title: "security".localized, message: error.title)
        } else {
            UIAlertService.showAlert(style: .alert, title: "error".localized, message: error.title)
        }
    }
    
    /// Call the appropriate method and display an error if necessary
    private func handleUserDeletionFromDatabase() {
        self.authenticationService.deleteUserFromDatabase { error in
            if let error = error {
                UIAlertService.showAlert(style: .alert, title: "error".localized, message: error.title)
            }
        }
    }
    
    /// Removes user authentication and data
    private func handleUserDeletion() {
        handleUserDeletionFromDatabase()
        
        authenticationService.deleteUserAuthentication { [weak self] error in
            if let error = error {
                self?.handleUserDeletionWith(error)
                return
            }
            
            self?.navigationController?.popToRootViewController(animated: true)
            UIAlertService.showAlert(style: .alert, title: nil, message: "deleted_account".localized)
        }
    }
}
