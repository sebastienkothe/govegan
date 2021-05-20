//
//  String.swift
//  govegan
//
//  Created by Mosma on 20/05/2021.
//

import Foundation

extension String {
    
    // MARK: - Internal properties
    static let pickUpUserInformationView = "PickUpUserInformationView"
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
