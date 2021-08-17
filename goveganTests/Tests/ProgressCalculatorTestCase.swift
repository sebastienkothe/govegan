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
    var components: Set<Calendar.Component>!
    var dateFormatter: DateFormatter!
    
    override func setUp() {
        super.setUp()
        progressCalculator = ProgressCalculator()
        progressCalculatorDelegateMock = ProgressCalculatorDelegateMock()
        progressCalculator.delegate = progressCalculatorDelegateMock
        
        userCalendar = Calendar.current
        components = [.year, .day, .hour, .minute, .second]
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
    }
    
    func test_GivenTwoDatesWithOneMinuteDifference_WhenCheckTheTimeToDisplayIsCalled_ThenItShouldReturnOneMinuteAsString() {
        
        checkTheDifferencesBetweenTwoDates(dates: ["01/01/2001 02:00", "01/01/2001 02:01"], expectedResult: ["0\n\("hour".localized)", "1\nminute", "0\n\("second".localized)"])
    }
    
    func test_GivenTwoDatesWithOneDayDifference_WhenCheckTheTimeToDisplayIsCalled_ThenItShouldReturnOneDayAsString() {
        
        checkTheDifferencesBetweenTwoDates(dates: ["01/01/2001 02:00", "02/01/2001 02:00"], expectedResult: ["1\n\("day".localized)", "0\n\("hour".localized)", "0\nminute"])
    }
    
    func test_GivenTwoDatesWithOneYearDifference_WhenCheckTheTimeToDisplayIsCalled_ThenItShouldReturnOneYearAsString() {
        
        checkTheDifferencesBetweenTwoDates(dates: ["01/01/2001 02:00", "01/01/2002 02:00"], expectedResult: ["1\n\("year".localized)", "0\n\("day".localized)", "0\n\("hour".localized)"])
    }
    
    func test_GivenTwoDatesWithDifferences_WhenCheckTheTimeToDisplayIsCalled_ThenItShouldShowPluralUnits() {
        
        checkTheDifferencesBetweenTwoDates(dates: ["01/01/2001 02:00", "03/03/2003 04:00"], expectedResult: ["2\n\("year".localized)s", "61\n\("day".localized)s", "2\n\("hour".localized)s"])
    }
    
    func test_GivenTwoDatesWithSecondAndMinuteDifferences_WhenCheckTheTimeToDisplayIsCalled_ThenItShouldShowPluralUnits() {
        
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        
        checkTheDifferencesBetweenTwoDates(dates: ["01/01/2001 00:00:00", "01/01/2001 00:02:02"], expectedResult: ["0\n\("hour".localized)", "2\nminutes", "2\n\("second".localized)s"])
    }
    
    func test_GivenTwoDatesWithOneYearDifference_WhenWeCallCheckTheTimeToDisplayWithADateComponentsWithoutYear_ThenItShouldReturnAnEmptyArray() {
        
        components = [.day, .hour, .minute, .second]
        checkTheDifferencesBetweenTwoDates(dates: ["01/01/2001 02:00", "01/01/2002 02:00"], expectedResult: [])
    }
    
    func test_GivenTimeDataWorth100years_WhenWeCallCalculateTheProgress_ThenShouldReturnThisData() {
        
        // Given
        let earlyDate = userCalendar.date(
            byAdding: .year,
            value: -100,
            to: Date())
        
        let timeElapsed = userCalendar.dateComponents([.year, .day, .hour, .minute, .second], from: earlyDate!, to: Date())
        
        _ = progressCalculator.checkTheTimeToDisplay(timeElapsed: timeElapsed)
        
        // When
        progressCalculator.calculateTheProgress()
        
        // Then
        // Data obtained by taking into account the bisextile years
        XCTAssertEqual(progressCalculatorDelegateMock.data, [36524.22, 661088.382, 152083199.658, 102267.81599999998, 332370.402])
    }
    
    func test_GivenDefaultGoalsAreSet_WhenWeCallUpdateProgressLayer_ThenShouldReturnAConsistentGoalAndPercentageProgression() {
        
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
    
    func test_GivenDefaultGoalsAreSet_WhenWeCallProvideComposedText_ThenShouldReturnAppropriateString() {
        
        // Given
        progressCalculator.objectives = [50, 90, 8740, 2, 40]
        
        // When
        for index in 0..<progressCalculator.objectives.count {
            
            let firstPartOfText = progressCalculator.objectives[index].formattedWithSeparator
            let additionalText = " \(AchievementsProvider().achievements[index].unitOfMeasure)"
            
            // Then
            XCTAssertEqual(progressCalculator.provideComposedText(index, additionalText).string, "\(firstPartOfText)" + "\(additionalText)")
        }
    }
    
    // MARK: - Private methods
    
    /// Compare by date and check the differences between them
    private func checkTheDifferencesBetweenTwoDates(dates: [String], expectedResult: [String]) {
        
        // Given
        let fromDate = dateFormatter.date(from: dates[0])
        let toDate = dateFormatter.date(from: dates[1])
        
        // When
        let timeElapsed = userCalendar.dateComponents(components, from: fromDate!, to: toDate!)
        let returnedValue = progressCalculator.checkTheTimeToDisplay(timeElapsed: timeElapsed)
        
        // Then
        XCTAssertEqual(returnedValue, expectedResult)
    }
}
