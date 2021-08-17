//
//  NumberFormatter.swift
//  govegan
//
//  Created by Mosma on 17/08/2021.
//

import Foundation

extension NumberFormatter {
    
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        return formatter
    }()
}
