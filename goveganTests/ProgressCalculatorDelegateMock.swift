//
//  ProgressCalculatorDelegateMock.swift
//  goveganTests
//
//  Created by Mosma on 07/06/2021.
//

@testable import govegan

class ProgressCalculatorDelegateMock: ProgressCalculatorDelegate {
    
    var data: [Double]?
    
    func progressCanBeUpdated(data: [Double]) {
        self.data = data
    }
}

