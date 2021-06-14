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
    // MARK: - Private functions
    
    // MARK: - Internal functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBActions
    @IBAction func didTapOnSignOutButton() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
