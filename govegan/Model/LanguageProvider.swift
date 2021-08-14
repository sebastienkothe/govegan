//
//  LanguageProvider.swift
//  govegan
//
//  Created by Mosma on 13/08/2021.
//

import Foundation

class LanguageProvider {
    
    // MARK: - Internal properties
    
    /// Gives the language currently used by the device
    var getDeviceLanguage: String? {
        return Locale.preferredLanguages.first?.components(separatedBy: "-").first
    }
}
