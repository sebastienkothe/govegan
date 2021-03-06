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
    override init() {
        super.init()
        setupFirebase()
    }
    
    // MARK: - Internal properties
    var window: UIWindow?
    
    // MARK: - Private functions
    
    /// Setting up the firebase instance
    private func setupFirebase() {
        FirebaseApp.configure()
    }
}
