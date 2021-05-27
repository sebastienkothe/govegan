//
//  ProgressCalculator.swift
//  govegan
//
//  Created by Mosma on 25/05/2021.
//

import Foundation

class ProgressCalculator {
    
    // MARK: - Internal properties
    var progressIsCalculated: (() -> Void)?
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
        let savedAnimalPerSecond = savedAnimalPerDay / 24 / 60 / 60
        let savedGrainPerSecond = savedGrainPerDay / 24 / 60 / 60
        let savedWaterPerSecond = savedWaterPerday / 24 / 60 / 60
        let savedForestPerSecond = savedForestPerDay / 24 / 60 / 60
        let savedCO2PerSecond = savedCO2PerDay / 24 / 60 / 60
        
        let elapsedTimeInSecondsFromMinute = Double(timeData[1]) * 60.0
        let elapsedTimeInSecondsFromHour = Double(timeData[2]) * 60.0 * 60.0
        let elapsedTimeInSecondsFromDay = Double(timeData[3]) * 60.0 * 60.0 * 24.0
        let elapsedTimeInSecondsFromYear = Double(timeData[4]) * 60.0 * 60.0 * 24.0 * 365.0
        
        let totalTime = Double(timeData[0]) + elapsedTimeInSecondsFromMinute + elapsedTimeInSecondsFromHour + elapsedTimeInSecondsFromDay + elapsedTimeInSecondsFromYear
        
        /// To update progressBar
        animalSaved = savedAnimalPerSecond * totalTime
        
        let animalSaved = convertToStringFrom(floor(savedAnimalPerSecond * totalTime), numberOfDecimal: 0)
        let grainSaved = convertToStringFrom(savedGrainPerSecond * totalTime, numberOfDecimal: 0)
        let waterSaved = convertToStringFrom(savedWaterPerSecond * totalTime, numberOfDecimal: 0)
        let forestSaved = convertToStringFrom(savedForestPerSecond * totalTime, numberOfDecimal: 0)
        let CO2saved = convertToStringFrom(savedCO2PerSecond * totalTime, numberOfDecimal: 0)
        
        return [
            animalSaved, grainSaved, waterSaved, forestSaved, CO2saved
        ]
    }
    
    func computeTheProgressBarPercent() -> Float {
        return Float(1.0 - (floor(animalSaved + 1.0) - animalSaved))
    }
    
    // MARK: - private properties
    private let savedGrainPerDay = 18.1 // 18
    private let savedCO2PerDay = 9.1 // 9
    private let savedWaterPerday = 4163.9 // 4163
    private let savedForestPerDay = 2.8 // 3
    private let savedAnimalPerDay = 1.0
    
    // MARK: - private functions
    private func convertToStringFrom(_ number: Double, numberOfDecimal: Int) -> String{
        return String(format: "%.\(String(numberOfDecimal))f", number)
    }
    
}
