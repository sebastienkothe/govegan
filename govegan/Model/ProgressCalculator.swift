//
//  ProgressCalculator.swift
//  govegan
//
//  Created by Mosma on 25/05/2021.
//

import Foundation

class ProgressCalculator {
    
    // MARK: - Internal properties
    weak var delegate: ProgressCalculatorDelegate?
    
    var progressCalculated: [Double] = [] {
        didSet {
            delegate?.progressCanBeUpdated(data: progressCalculated)
        }
    }
    
    var timeData: [Int] = []
    var animalSaved: Double = 0.0
    
    // MARK: - Internal functions
    func checkTheTimeToDisplay(timeElapsed: DateComponents) -> [String] {
        guard let second = timeElapsed.second, let minute = timeElapsed.minute, let hour = timeElapsed.hour, let day = timeElapsed.day, let year = timeElapsed.year else { return [] }
        
        timeData = [second, minute, hour, day, year]
        
        var secondText = "second".localized
        var minuteText = "minute".localized
        var hourText = "hour".localized
        var dayText = "day".localized
        var yearText = "year".localized
        
        if second > 1 { secondText += "s" }
        if minute > 1 { minuteText += "s" }
        if hour > 1 { hourText += "s" }
        if day > 1 { dayText += "s" }
        if year > 1 { yearText += "s" }
        
        if year >= 1 {
            return ["\(year)\n\(yearText)", "\(day)\n\(dayText)", "\(hour)\n\(hourText)"]
        } else if day < 1 {
            return ["\(hour)\n\(hourText)", "\(minute)\n\(minuteText)", "\(second)\n\(secondText)"]
        } else {
            return ["\(day)\n\(dayText)", "\(hour)\n\(hourText)", "\(minute)\n\(minuteText)"]
        }
    }
    
    func calculateTheProgress() -> [String] {
        let savedAnimalPerSecond = convertDailyDataToSeconds(1.0)
        let savedGrainPerSecond = convertDailyDataToSeconds(18.1)
        let savedWaterPerSecond = convertDailyDataToSeconds(4163.9)
        let savedForestPerSecond = convertDailyDataToSeconds(2.8)
        let savedCO2PerSecond = convertDailyDataToSeconds(9.1)
        
        let elapsedTimeInSecondsFromMinutes = Double(timeData[1]) * 60.0
        let elapsedTimeInSecondsFromHours = Double(timeData[2]) * 60.0 * 60.0
        let elapsedTimeInSecondsFromDays = Double(timeData[3]) * 60.0 * 60.0 * 24.0
        let elapsedTimeInSecondsFromYears = Double(timeData[4]) * 60.0 * 60.0 * 24.0 * 365.0
        
        let totalTimeInSeconds = Double(timeData[0]) + elapsedTimeInSecondsFromMinutes + elapsedTimeInSecondsFromHours + elapsedTimeInSecondsFromDays + elapsedTimeInSecondsFromYears
        
        /// To update progressBar
        animalSaved = savedAnimalPerSecond * totalTimeInSeconds
        
        let animalSavedToString = convertToStringFrom(floor(savedAnimalPerSecond * totalTimeInSeconds), numberOfDecimal: 0)
        let grainSavedToString = convertToStringFrom(savedGrainPerSecond * totalTimeInSeconds, numberOfDecimal: 0)
        let waterSavedToString = convertToStringFrom(savedWaterPerSecond * totalTimeInSeconds, numberOfDecimal: 0)
        let forestSavedToString = convertToStringFrom(savedForestPerSecond * totalTimeInSeconds, numberOfDecimal: 0)
        let CO2savedToString = convertToStringFrom(savedCO2PerSecond * totalTimeInSeconds, numberOfDecimal: 0)
        
        let animalSaved = savedAnimalPerSecond * totalTimeInSeconds
        let grainSaved = savedGrainPerSecond * totalTimeInSeconds
        let waterSaved = savedWaterPerSecond * totalTimeInSeconds
        let forestSaved = savedForestPerSecond * totalTimeInSeconds
        let CO2saved = savedCO2PerSecond * totalTimeInSeconds
        
        progressCalculated = [animalSaved,
                               grainSaved,
                               waterSaved,
                               forestSaved,
                               CO2saved]
        
        return [
            animalSavedToString, grainSavedToString, waterSavedToString, forestSavedToString, CO2savedToString
        ]
    }
    
    func computeProgressPercent() -> Float {
        return Float(1.0 - (floor(animalSaved + 1.0) - animalSaved))
    }
    
    
    
    // MARK: - private properties
    
    // MARK: - private functions
    private func convertToStringFrom(_ number: Double, numberOfDecimal: Int) -> String{
        return String(format: "%.\(String(numberOfDecimal))f", number)
    }
    
    private func convertDailyDataToSeconds(_ dailyObjective: Double) -> Double {
       return dailyObjective / 24 / 60 / 60
    }
    
}
