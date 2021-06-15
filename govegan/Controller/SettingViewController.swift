//
//  SettingViewController.swift
//  govegan
//
//  Created by Mosma on 30/05/2021.
//

import UIKit
import Firebase

class SettingViewController: UIViewController {
    // MARK: - Internal properties
    // MARK: - Internal functions
    // MARK: - IBOutlets
    // MARK: - IBActions
    // MARK: - Private properties
    
    
    // MARK: - Internal functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBActions
    @IBAction func didTapOnSignOutButton() {
        HandleLogOut()
    }
    
    // MARK: - Private functions
    
    ///Displays an alert and acts according to the user's wish
    private func HandleLogOut() {
        let cancel = UIAlertAction(title: "cancel".localized, style: .cancel)
        let okay = UIAlertAction(title: "yes".localized, style: .default) { [weak self] _ in
            self?.disconnectUserFromApp()
        }
        
        UIAlertService.showAlert(style: .alert, title: nil, message: "disconnection_question".localized, actions: [okay, cancel], completion: nil)
    }
    
    /// Try to log the user out of the app
    private func disconnectUserFromApp() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.navigationController?.popToRootViewController(animated: true)
        } catch {
            UIAlertService.showAlert(style: .alert, title: "error".localized, message: "unable_to_log_out".localized)
        }
    }
}
