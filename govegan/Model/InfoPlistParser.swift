//
//  InfoPlistParser.swift
//  govegan
//
//  Created by Mosma on 03/06/2021.
//

import Foundation

struct InfoPlistParser {
    
    static func getStringValue(forKey: String) -> String {
        guard let value = Bundle.main.infoDictionary?[forKey] as? String else {
            fatalError("No value found for key '\(forKey)' in the Info.plist file")
        }
        return value
    }
    
}
