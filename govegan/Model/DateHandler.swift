//
//  DateHandler.swift
//  govegan
//
//  Created by Mosma on 13/08/2021.
//

import UIKit

class DateHandler {
    
    // MARK: - Internal methods
    
    /// Converts the date into a string taking into account the language of the device
    func convertDateAsString(date: Date) -> String? {
        
        guard let language = languageProvider.getDeviceLanguage else { return nil }
        
        let deviceLanguage = language == "fr" ? "fr-FR" : "en-EN"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: deviceLanguage)
        
        return dateFormatter.string(from: date)
    }
    
    // MARK: - Private properties
    private let languageProvider = LanguageProvider()
}
