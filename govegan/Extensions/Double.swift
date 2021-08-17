//
//  Double.swift
//  govegan
//
//  Created by Mosma on 17/08/2021.
//

import Foundation

extension Double {
    
    var formattedWithSeparator: String {
        return NumberFormatter.withSeparator.string(for: self) ?? ""
    }
}
