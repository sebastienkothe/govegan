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
    var achievements: [Achievement]!
    var components: Set<Calendar.Component>!
    
    
    override func setUp() {
        super.setUp()
        progressCalculator = ProgressCalculator()
        progressCalculatorDelegateMock = ProgressCalculatorDelegateMock()
        progressCalculator.delegate = progressCalculatorDelegateMock
        userCalendar = Calendar.current
        achievements = AchievementsProvider().achievements
        components = [.year, .day, .hour, .minute, .second]
    }
    
    func testGivenTwoDatesWithOneMinuteDifference_WhenWeCallCheckTheTimeToDisplay_ThenItShouldReturnOneMinuteAsString() {
        
        checkTheDifferencesBetweenTwoDates(dates: ["01/01/2001 02:00", "01/01/2001 02:01"], expectedResult: ["0\n\("hour".localized)", "1\nminute", "0\n\("second".localized)"])
    }
    
    func testGivenTwoDatesWithOneDayDifference_WhenWeCallCheckTheTimeToDisplay_ThenItShouldReturnOneDayAsString() {
        
        checkTheDifferencesBetweenTwoDates(dates: ["01/01/2001 02:00", "02/01/2001 02:00"], expectedResult: ["1\n\("day".localized)", "0\n\("hour".localized)", "0\nminute"])
    }
    
    func testGivenTwoDatesWithOneYearDifference_WhenWeCallCheckTheTimeToDisplay_ThenItShouldReturnOneYearAsString() {
        
        checkTheDifferencesBetweenTwoDates(dates: ["01/01/2001 02:00", "01/01/2002 02:00"], expectedResult: ["1\n\("year".localized)", "0\n\("day".localized)", "0\n\("hour".localized)"])
    }
    
    func testGivenTwoDatesWithDifferences_WhenWeCallCheckTheTimeToDisplay_ThenItShouldShowPluralUnits() {
        
        checkTheDifferencesBetweenTwoDates(dates: ["01/01/2001 02:00", "03/03/2003 04:00"], expectedResult: ["2\n\("year".localized)s", "61\n\("day".localized)s", "2\n\("hour".localized)s"])
    }
    
    func testGivenTwoDatesWithSecondAndMinuteDifferences_WhenWeCallCheckTheTimeToDisplay_ThenItShouldShowPluralUnits() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        
        // Given
        fromDate = dateFormatter.date(from: "01/01/2001 00:00:00")
        toDate = dateFormatter.date(from: "01/01/2001 00:02:02")
        
        // When
        timeElapsed = userCalendar.dateComponents(components, from: fromDate!, to: toDate!)
        let returnedValue = progressCalculator.checkTheTimeToDisplay(timeElapsed: timeElapsed)
        
        // Then
        XCTAssertEqual(returnedValue, ["0\n\("hour".localized)", "2\nminutes", "2\n\("second".localized)s"])
    }
    
    func testGivenTwoDatesWithOneYearDifference_WhenWeCallCheckTheTimeToDisplayWithADateComponentsWithoutYear_ThenItShouldReturnAnEmptyArray() {
        
        components = [.day, .hour, .minute, .second]
        checkTheDifferencesBetweenTwoDates(dates: ["01/01/2001 02:00", "01/01/2002 02:00"], expectedResult: [])
    }
    
    func testGivenTimeDataWorth100years_WhenWeCallCalculateTheProgress_ThenShouldReturnThisData() {
        
        // Given
        let earlyDate = userCalendar.date(
          byAdding: .year,
          value: -100,
          to: Date())
        
        let timeElapsed = userCalendar.dateComponents([.year, .day, .hour, .minute, .second], from: earlyDate!, to: Date())
        
        _ = progressCalculator.checkTheTimeToDisplay(timeElapsed: timeElapsed)
        
        // When
        let result = progressCalculator.calculateTheProgress()
        
        // Then
        
        /* animalSaved, grainSaved, waterSaved, forestSaved, CO2saved
         Data without taking into account the bisextile years */
        XCTAssertNotEqual(result, ["36500", "660650", "151982350", "102200", "332150"])
        
        
        // Data obtained by taking into account the bisextile years
        XCTAssertEqual(result, ["36524", "661088", "152083200", "102268", "332370"])
    }
    
    func testGivenDefaultGoalsAreSet_WhenWeCallUpdateProgressLayer_ThenShouldReturnAConsistentGoalAndPercentageProgression() {
        
        // Given
        progressCalculator.objectives = AchievementsProvider.basicGoals
        
        // When
        let expectedPercentage = [0.55, 0.7730769230769231, 0.7692478632478633, 0.7769230769230769, 0.7630434782608696]
        let currentProgressions = [1.1, 20.1, 4500.1, 10.1, 35.1]
        
        for index in 0..<progressCalculator.objectives.count {
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
        for index in 0..<progressCalculator.objectives.count {
            
            let firstPartOfText = String(format: "%.\(String(0))f", progressCalculator.objectives[index].rounded(.towardZero))
            let additionalText = " \(achievements[index].unitOfMeasure)"
            
            // Then
            XCTAssertEqual(progressCalculator.provideComposedText(index, additionalText).string, "\(firstPartOfText)" + "\(additionalText)")
        }
        
        
    }
    
    // MARK: - Private methods
    
    /// Compare by date and check the differences between them
    private func checkTheDifferencesBetweenTwoDates(dates: [String], expectedResult: [String]) {
        // Given
        fromDate = progressCalculator.convertDate(dates[0])
        toDate = progressCalculator.convertDate(dates[1])
        
        // When
        timeElapsed = userCalendar.dateComponents(components, from: fromDate!, to: toDate!)
        let returnedValue = progressCalculator.checkTheTimeToDisplay(timeElapsed: timeElapsed)
        
        // Then
        XCTAssertEqual(returnedValue, expectedResult)
    }
}
