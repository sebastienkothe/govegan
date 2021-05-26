//
//  ProgressCalculator.swift
//  govegan
//
//  Created by Mosma on 25/05/2021.
//

import Foundation

class ProgressCalculator {
    
    /*
     18,1 kg cereales par jour
     9,1 kg CO2 par jour
     4163,9 litres eau par jour
     2,8 m2 forêt par jour
     1 animal par jour
     */
    
    // MARK: - Internal properties
    var progressIsCalculated: (() -> Void)?
    var timeData: [Int] = []
    
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
        
//        if day >= 1 || year >= 1 {
//            let numberOfDays = day + (year * 365)
//
//            valuesToReturn.append(String(numberOfDays))
//            valuesToReturn.append(String(Float(numberOfDays) * 18.1))
//        }
    }
    
    // MARK: - private properties
    private let savedGrainPerDay = 18.1 // 18
    private let savedCO2PerDay = 9.1 // 9
    private let savedWaterPerday = 4163.9 // 4163
    private let savedForestPerDay = 2.8 // 3
    private let savedAnimalPerDay = 1
    
    // MARK: - private functions
    
    
}
