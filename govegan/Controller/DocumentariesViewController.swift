//
//  DocumentariesViewController.swift
//  govegan
//
//  Created by Mosma on 23/05/2021.
//

import UIKit
import Firebase

class DocumentariesViewController: UIViewController {
    
    // MARK: - Internal properties
    
    // MARK: - Internal functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBOutlets
    
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
    
    // MARK: - private properties
    
    // MARK: - private functions
    
    
}
