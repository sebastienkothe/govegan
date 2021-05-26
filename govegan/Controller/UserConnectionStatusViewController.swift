//
//  UserConnectionStatusViewController.swift
//  govegan
//
//  Created by Mosma on 24/05/2021.
//

import UIKit
import Firebase

class UserConnectionStatusViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        do {
//            sleep(1)
//        }
        
        let userIsConnected: Bool
        userIsConnected = Auth.auth().currentUser != nil ? true : false
        
        if userIsConnected {
            performSegue(withIdentifier: "segueToDashboardTabBarController", sender: nil)
        } else {
            performSegue(withIdentifier: "segueToWelcomeViewController", sender: nil)
        }
    }
}
