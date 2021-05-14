//
//  ViewController.swift
//  govegan
//
//  Created by Mosma on 13/05/2021.
//

import UIKit
import FirebaseUI

class ViewController: UIViewController, FUIAuthDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        // Instantiation of FirebaseUI as a default authentication UI
        if let authUI = FUIAuth.defaultAuthUI() {
            if #available(iOS 13.0, *) {
                // FirebaseUI supports multiple sign-in providers
                authUI.providers = [FUIOAuth.appleAuthProvider()]
            } else {
                authUI.providers = []
                // Fallback on earlier versions
            }
            authUI.delegate = self
            
            // We retrieve the auth controller
            let authViewController = authUI.authViewController()
            self.present(authViewController, animated: true)
        }
    }
    
    /// This callback has two parameters, one with the result of the authentication process and another one in case something went wrong
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        // We can extract the signed-in user from the auth data result...
        if let user = authDataResult?.user {
            // and then print their user ID and other data, such as the display name or their email address
            print("Nice! You've signed in as \(user.uid). Your email \(user.email ?? "")")
        }
    }
    
}

