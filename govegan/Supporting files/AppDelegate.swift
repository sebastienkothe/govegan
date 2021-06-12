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
        
        setupFirebase()
        checkIfUnitTestsAreRunning()
    }
    
    // MARK: - Internal properties
    var window: UIWindow?
    
    // MARK: - Private functions
    
    /// Setting up the firebase instance
    private func setupFirebase() {
        FirebaseApp.configure()
    }
    
    // Setting up Firebase local emulator connection only for tests
    
    /// Checking if unit tests are running
    private func checkIfUnitTestsAreRunning() {
        if ProcessInfo.processInfo.environment["unit_tests"] == "true" {
            print("Setting up Firebase emulator localhost:6060")
            let settings = Firestore.firestore().settings
            settings.host = "localhost:6060"
            settings.isPersistenceEnabled = false
            settings.isSSLEnabled = false
            Firestore.firestore().settings = settings
        }
    }
}
