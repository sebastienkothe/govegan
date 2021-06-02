//
//  AppDelegate.swift
//  govegan
//
//  Created by Mosma on 13/05/2021.
//

import UIKit
import Firebase
import FBSDKCoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // Makes sure the configure code gets executed when AppDelegate is initialised
    override init() {
        super.init()
        
        // Setting up the firebase instance
        setupFirebase()
    }
    
    // MARK: - Internal properties
    var window: UIWindow?
    
    // MARK: - Internal functions
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
        
    }
    
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    // MARK: - Private functions
    private func setupFirebase() {
        FirebaseApp.configure()
    }
    
}

