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
    var progressCalculatorDelegateMock: ProgressCalculatorDelegateMock!
    var userCalendar: Calendar!
    var timeElapsed: DateComponents!
    var fromDate: Date!
    var toDate: Date!
    var achievementCellElementsProvider: AchievementCellElementsProvider!
    
    
    override func setUp() {
        super.setUp()
        progressCalculator = ProgressCalculator()
        progressCalculatorDelegateMock = ProgressCalculatorDelegateMock()
        progressCalculator.delegate = progressCalculatorDelegateMock
        userCalendar = Calendar.current
        achievementCellElementsProvider = AchievementCellElementsProvider()
    }
    
    func testGivenProgressCalculatedIsEmpty_WhenProgressCalculatedIsChanged_ThenDelegateShouldGetTheNewValue() {
        
        // Given
        progressCalculator.progressCalculated = []
        
        // When
        progressCalculator.progressCalculated = [1]
        
        // Then
        XCTAssertEqual(progressCalculatorDelegateMock.data, [1])
    }
    
    func testGivenTwoDatesWithOneMinuteDifference_WhenWeCallCheckTheTimeToDisplay_ThenItShouldReturnOneMinuteAsString() {
        
        // Given
        fromDate = progressCalculator.convertDate("01/01/2001 02:00")
        toDate = progressCalculator.convertDate("01/01/2001 02:01")
        
        // When
        timeElapsed = userCalendar.dateComponents([.year, .day, .hour, .minute, .second], from: fromDate!, to: toDate!)
        let returnedValue = progressCalculator.checkTheTimeToDisplay(timeElapsed: timeElapsed)
        
        // Then
        XCTAssertEqual(returnedValue, ["0\nheure", "1\nminute", "0\nseconde"])
    }
    
    func testGivenTwoDatesWithOneDayDifference_WhenWeCallCheckTheTimeToDisplay_ThenItShouldReturnOneDayAsString() {
        
        // Given
        fromDate = progressCalculator.convertDate("01/01/2001 02:00")
        toDate = progressCalculator.convertDate("02/01/2001 02:00")
        
        // When
        timeElapsed = userCalendar.dateComponents([.year, .day, .hour, .minute, .second], from: fromDate!, to: toDate!)
        let returnedValue = progressCalculator.checkTheTimeToDisplay(timeElapsed: timeElapsed)
        
        // Then
        XCTAssertEqual(returnedValue, ["1\njour", "0\nheure", "0\nminute"])
    }
    
    func testGivenTwoDatesWithOneYearDifference_WhenWeCallCheckTheTimeToDisplay_ThenItShouldReturnOneYearAsString() {
        
        // Given
        fromDate = progressCalculator.convertDate("01/01/2001 02:00")
        toDate = progressCalculator.convertDate("01/01/2002 02:00")
        
        // When
        timeElapsed = userCalendar.dateComponents([.year, .day, .hour, .minute, .second], from: fromDate!, to: toDate!)
        let returnedValue = progressCalculator.checkTheTimeToDisplay(timeElapsed: timeElapsed)
        
        // Then
        XCTAssertEqual(returnedValue, ["1\nannée", "0\njour", "0\nheure"])
    }
    
    func testGivenTwoDatesWithDifferences_WhenWeCallCheckTheTimeToDisplay_ThenItShouldShowPluralUnits() {
        
        // Given
        fromDate = progressCalculator.convertDate("01/01/2001 02:00")
        toDate = progressCalculator.convertDate("03/03/2003 04:00")
        
        // When
        timeElapsed = userCalendar.dateComponents([.year, .day, .hour, .minute, .second], from: fromDate!, to: toDate!)
        let returnedValue = progressCalculator.checkTheTimeToDisplay(timeElapsed: timeElapsed)
        
        // Then
        XCTAssertEqual(returnedValue, ["2\nannées", "61\njours", "2\nheures"])
    }
    
    func testGivenTwoDatesWithSecondAndMinuteDifferences_WhenWeCallCheckTheTimeToDisplay_ThenItShouldShowPluralUnits() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        
        // Given
        fromDate = dateFormatter.date(from: "01/01/2001 00:00:00")
        toDate = dateFormatter.date(from: "01/01/2001 00:02:02")
        
        // When
        timeElapsed = userCalendar.dateComponents([.year, .day, .hour, .minute, .second], from: fromDate!, to: toDate!)
        let returnedValue = progressCalculator.checkTheTimeToDisplay(timeElapsed: timeElapsed)
        
        // Then
        XCTAssertEqual(returnedValue, ["0\nheure", "2\nminutes", "2\nsecondes"])
    }
    
    func testGivenTwoDatesWithOneYearDifference_WhenWeCallCheckTheTimeToDisplayWithADateComponentsWithoutYear_ThenItShouldReturnAnEmptyArray() {
        
        // Given
        fromDate = progressCalculator.convertDate("01/01/2001 02:00")
        toDate = progressCalculator.convertDate("01/01/2002 02:00")
        
        // When
        timeElapsed = userCalendar.dateComponents([.day, .hour, .minute, .second], from: fromDate!, to: toDate!)
        let returnedValue = progressCalculator.checkTheTimeToDisplay(timeElapsed: timeElapsed)
        
        // Then
        XCTAssertEqual(returnedValue, [])
    }
    
    func testGivenTimeDataWorth100years_WhenWeCallCalculateTheProgress_ThenShouldReturnThisData() {
        
        // Given
        
        //  timeData = [second, minute, hour, day, year]
        progressCalculator.timeData = [0, 0, 0, 0, 100]
        
        // When
        let result = progressCalculator.calculateTheProgress()
        
        // Then
        
        /* animalSaved, grainSaved, waterSaved, forestSaved, CO2saved
         Data without taking into account the bisextile years */
        XCTAssertNotEqual(result, ["36500", "660650", "151982350", "102200", "332150"])
        
        
        // Data obtained by taking into account the bisextile years
        XCTAssertEqual(result, ["36524", "661088", "152083200", "102268", "332370"])
    }
    
    func testGivenTimeDataWorth1Month_WhenWeCallCalculateTheProgress_ThenShouldReturnThisData() {
        
        // Given
        //  timeData = [second, minute, hour, day, year]
        progressCalculator.timeData = [0, 0, 0, 30, 0]
        
        // When
        let result = progressCalculator.calculateTheProgress()
        
        // Then
        XCTAssertEqual(result, ["30", "543", "124917", "84", "273"])
    }
    
    func testGivenTimeDataWorth1Day_WhenWeCallCalculateTheProgress_ThenShouldReturnThisData() {
        
        // Given
        
        //  timeData = [second, minute, hour, day, year]
        progressCalculator.timeData = [0, 0, 23, 0, 0]
        
        // When
        let result = progressCalculator.calculateTheProgress()
        
        // Then
        // 0,958333333333333 - 17,345833333333333 - 3990,404166666666667 - 2,683333333333333 - 8,720833333333333
        XCTAssertEqual(result, ["0", "17", "3990", "3", "9"])
    }
    
    func testGivenDefaultGoalsAreSet_WhenWeCallUpdateProgressLayer_ThenShouldReturnAConsistentGoalAndPercentageProgression() {
        
        // Given
        progressCalculator.objectives = [1, 20, 4500, 10, 35]
        
        // When
        let expectedPercentage = [0.55, 0.7730769230769231, 0.7692478632478633, 0.7769230769230769, 0.7630434782608696]
        let currentProgressions = [1.1, 20.1, 4500.1, 10.1, 35.1]
        
        for (index, _) in progressCalculator.objectives.enumerated() {
            XCTAssertEqual(progressCalculator.updateProgressLayer(index: index, calculatedProgress: currentProgressions[index]), CGFloat(expectedPercentage[index]))
        }
        
        // Then
        //            CGFloat(1 / (objective / calculatedProgress))
        XCTAssertEqual(progressCalculator.objectives, [2, 26, 5850, 13, 46])
    }
    
    func testGivenDefaultGoalsAreSet_WhenWeCallProvideComposedText_ThenShouldReturnAppropriateString() {
        
        // Given
        progressCalculator.objectives = [50, 90, 8740, 2, 40]
        
        // When
        for (index, _) in progressCalculator.objectives.enumerated() {
            
            let firstPartOfText = String(format: "%.\(String(0))f", progressCalculator.objectives[index].rounded(.towardZero))
            let additionalText = " \(achievementCellElementsProvider.objectiveInformations[index])"
            
            // The,
            XCTAssertEqual(progressCalculator.provideComposedText(index, additionalText).string, "\(firstPartOfText)" + "\(additionalText)")
        }
        
        
    }
}
