//
//  String.swift
//  govegan
//
//  Created by Mosma on 20/05/2021.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    // View
    static let pickUpUserInformationView = "PickUpUserInformationView"
    
    // Controller
    static let signUpViewController = "SignUpViewController"
    
    // Segue
    static let segueToTabBarFromLogin = "segueToTabBarFromLogin"
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
    
    // URL
    static let facts = "https://www.cowspiracy.com/facts"
    
    // FirestoreManager
    static let veganStartDateKey = "veganStartDate"
    static let usernameKey = "username"
    static let emailKey = "email"
    static let collectionName = "users"
}
