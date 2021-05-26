//
//  SceneDelegate.swift
//  govegan
//
//  Created by Mosma on 13/05/2021.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Internal properties
    var window: UIWindow?
    
    // MARK: - Internal functions
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
//
//        let userIsConnected: Bool
//        userIsConnected = Auth.auth().currentUser != nil ? true : false
//        
//
//        if userIsConnected {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//            // If user is logged in go to the tab controller
//            let dashboardTabBarController = storyboard.instantiateViewController(identifier: "DashboardTabBarController")
//            window?.rootViewController = dashboardTabBarController
//            window?.makeKeyAndVisible()
//        }
    }
}

