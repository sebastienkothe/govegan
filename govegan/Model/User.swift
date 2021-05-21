//
//  User.swift
//  govegan
//
//  Created by Mosma on 21/05/2021.
//

import Foundation

class User {
    
    // MARK: - Initializer
    init(name: String, veganStartDate: String, userID: String, email: String) {
        self.name = name
        self.veganStartDate = veganStartDate
        self.userID = userID
        self.email = email
    }
    
    // MARK: - Private properties
    let name: String
    let veganStartDate: String
    let userID: String
    let email: String

    
    // MARK: - Private functions
}
