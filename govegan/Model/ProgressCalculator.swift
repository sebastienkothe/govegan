//
//  ProgressCalculator.swift
//  govegan
//
//  Created by Mosma on 25/05/2021.
//

import UIKit

class ProgressCalculator {
    
    // MARK: - Internal properties
    weak var delegate: ProgressCalculatorDelegate?
    var objectives: [Double] = AchievementsProvider.basicGoals
    
    // MARK: - Internal methods
    
    /// Determine the goal based on progress
    func updateProgressLayer(index: Int, calculatedProgress: Double) -> CGFloat {
        
        while calculatedProgress > objectives[index]  {
            objectives[index] = ceil(objectives[index] * 1.3)
        }
        
        return CGFloat(1 / (objectives[index] / calculatedProgress))
    }
    
    /// Allows you to edit the text for the goal
    func provideComposedText(_ item: Int, _ additionalText: String) -> NSMutableAttributedString {
        
        let text = NSMutableAttributedString()
        
        let firstPartOfTheText = String(format: "%.\(String(0))f", objectives[item].rounded(.towardZero))
        let attributesForAdditionalText = [.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont(name: .avenirNext, size: 17)]
        
        text.append(NSAttributedString(string: firstPartOfTheText, attributes: [:]))
        text.append(NSAttributedString(string: additionalText, attributes: attributesForAdditionalText as [NSAttributedString.Key : Any]))
        return text
    }
    
    /// Returns the time to display
    func checkTheTimeToDisplay(timeElapsed: DateComponents) -> [String] {
        guard let second = timeElapsed.second, let minute = timeElapsed.minute, let hour = timeElapsed.hour, let day = timeElapsed.day, let year = timeElapsed.year else { return [] }
        
        timeData = [second, minute, hour, day, year]
        
        var secondText = "second".localized
        var minuteText = "minute".localized
        var hourText = "hour".localized
        var dayText = "day".localized
        var yearText = "year".localized
        
        checkIfPluralIsRequired(second, &secondText, minute, &minuteText, hour, &hourText, day, &dayText, year, &yearText)
        
        return adaptTextToReturn(year, yearText, day, dayText, hour, hourText, minute, minuteText, second, secondText)
    }
    
    /// Returns the current progress for each category
    func calculateTheProgress() -> [String] {
        
        let totalTimeInSeconds = Double(timeData[0]) + Double(timeData[1]) * 60.0 + Double(timeData[2]) * 60.0 * 60.0 + Double(timeData[3]) * 60.0 * 60.0 * 24.0 + Double(timeData[4]) * 60.0 * 60.0 * 24.0 * 365.2422
        
        let animalSaved = convertDailyDataToSeconds(1.0) * totalTimeInSeconds
        let grainSaved = convertDailyDataToSeconds(18.1) * totalTimeInSeconds
        let waterSaved = convertDailyDataToSeconds(4163.9) * totalTimeInSeconds
        let forestSaved = convertDailyDataToSeconds(2.8) * totalTimeInSeconds
        let CO2saved = convertDailyDataToSeconds(9.1) * totalTimeInSeconds
        
        progressCalculated = [animalSaved, grainSaved, waterSaved, forestSaved, CO2saved]
        
        return [
            convertToStringFrom(floor(animalSaved)), convertToStringFrom(grainSaved), convertToStringFrom(waterSaved), convertToStringFrom(forestSaved), convertToStringFrom(CO2saved)
        ]
    }
    
    // MARK: - Private properties
    private var timeData: [Int] = []
    
    private var progressCalculated: [Double] = [] {
        didSet {
            delegate?.progressCanBeUpdated(data: progressCalculated)
        }
    }
    
    // MARK: - private functions
    private func convertToStringFrom(_ number: Double) -> String{
        return String(format: "%.\(String(0))f", number)
    }
    
    private func convertDailyDataToSeconds(_ dailyObjective: Double) -> Double {
        return dailyObjective / 24 / 60 / 60
    }
    
    /// Checks if the test must be taken in the plural
    private func checkIfPluralIsRequired(_ second: Int, _ secondText: inout String, _ minute: Int, _ minuteText: inout String, _ hour: Int, _ hourText: inout String, _ day: Int, _ dayText: inout String, _ year: Int, _ yearText: inout String) {
        if second > 1 { secondText += "s" }
        if minute > 1 { minuteText += "s" }
        if hour > 1 { hourText += "s" }
        if day > 1 { dayText += "s" }
        if year > 1 { yearText += "s" }
    }
    
    /// Returns the text to display based on the date the user became vegan
    private func adaptTextToReturn(_ year: Int, _ yearText: String, _ day: Int, _ dayText: String, _ hour: Int, _ hourText: String, _ minute: Int, _ minuteText: String, _ second: Int, _ secondText: String) -> [String] {
        if year >= 1 {
            return ["\(year)\n\(yearText)", "\(day)\n\(dayText)", "\(hour)\n\(hourText)"]
        } else if day < 1 {
            return ["\(hour)\n\(hourText)", "\(minute)\n\(minuteText)", "\(second)\n\(secondText)"]
        } else {
            return ["\(day)\n\(dayText)", "\(hour)\n\(hourText)", "\(minute)\n\(minuteText)"]
        }
    }
}
