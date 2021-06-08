//
//  AppDelegate.swift
//  govegan
//
//  Created by Mosma on 13/05/2021.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Initializer
    
    // Makes sure the configure code gets executed when AppDelegate is initialised
    override init() {
        super.init()
        
        // Setting up the firebase instance
        setupFirebase()
    }
    
    // MARK: - Internal properties
    var window: UIWindow?
        
    // MARK: - Private functions
    private func setupFirebase() {
        FirebaseApp.configure()
    }
}
