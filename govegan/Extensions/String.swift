//
//  String.swift
//  govegan
//
//  Created by Mosma on 20/05/2021.
//

import Foundation

extension String {
    
    // MARK: - Internal properties
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    // View
    static let pickUpUserInformationView = "PickUpUserInformationView"
    
    // Controller
    static let loginViewController = "LoginViewController"
    static let signUpViewController = "SignUpViewController"
    
    // Segue
    static let segueToTabBarFromLogin = "segueToTabBarFromLogin"
    static let segueToLoginFromWelcome = "segueToLoginFromWelcome"
    static let segueToTabBarFromWelcome = "segueToTabBarFromWelcome"
    static let segueToTabBarFromSignUp = "segueToTabBarFromSignUp"
    static let segueToLoginFromSetting = "segueToLoginFromSetting"
    
    // Cell
    static let progressCell = "ProgressCell"
    static let achievementCell = "AchievementCell"
    static let documentaryCell = "DocumentaryCell"
    
    // Font
    static let avenirNext = "Avenir Next"
    
    // Main storyboard file base name
    static let mainStoryboard = "Main"
}
