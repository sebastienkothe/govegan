//
//  ProgressCalculatorTestCase.swift
//  goveganTests
//
//  Created by Mosma on 13/05/2021.
//

import XCTest
@testable import govegan

class ProgressCalculatorTestCase: XCTestCase {
    
    // MARK: - Properties
    var progressCalculator: ProgressCalculator!
    
    override func setUp() {
        super.setUp()
        progressCalculator = ProgressCalculator()
    }
    
    func testGivenScoreIsNull_WhenIncrementingPlayer1Score_ThenScoreShouldBeFifteen() {}
}
