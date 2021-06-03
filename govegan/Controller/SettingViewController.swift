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
            Hud.handle(hud, with: HudInfo(type: .success, text: "Success", detailText: "Successfully signed out"))
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            Hud.handle(hud, with: HudInfo(type: .error, text: "Error", detailText: signOutError.localizedDescription))
        }
    }
    
    // MARK: - Private properties
    private let hud = Hud.create()
}
