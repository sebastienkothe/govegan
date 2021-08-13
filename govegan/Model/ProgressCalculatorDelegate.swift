//
//  ProgressCalculatorDelegate.swift
//  govegan
//
//  Created by Mosma on 30/05/2021.
//

import Foundation

protocol ProgressCalculatorDelegate: AnyObject {
    func progressCanBeUpdated(data: [Double])
}
