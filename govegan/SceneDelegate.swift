//
//  SceneDelegate.swift
//  govegan
//
//  Created by Mosma on 13/05/2021.
//

import UIKit


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    @available(iOS 13.0, *)
    func sceneDidDisconnect(_ scene: UIScene) {}
    
    @available(iOS 13.0, *)
    func sceneDidBecomeActive(_ scene: UIScene) {}
    
    @available(iOS 13.0, *)
    func sceneWillResignActive(_ scene: UIScene) {}
    
    @available(iOS 13.0, *)
    func sceneWillEnterForeground(_ scene: UIScene) {}
    
    @available(iOS 13.0, *)
    func sceneDidEnterBackground(_ scene: UIScene) {}
    
}

