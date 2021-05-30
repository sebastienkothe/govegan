//
//  ProgressCellElementsProvider.swift
//  govegan
//
//  Created by Mosma on 22/05/2021.
//

import Foundation
import UIKit

struct ProgressCellElementsProvider {
    let images: [UIImage?] = [
        UIImage(named: "heart"), UIImage(named: "wheat"), UIImage(named: "water"), UIImage(named: "evergreen"), UIImage(named: "cloud")
        ]
    
    let titleForProgression = [
        "animal_lives".localized, "kg_of_grain".localized, "litres_of_water".localized, "sqm_of_forest".localized, "kg_of_co2".localized
    ]
    
    /*
     18,1 kg cereales par jour
     9,1 kg CO2 par jour
     4163,9 litres eau par jour
     2,8 m2 forêt par jour
     1 animal par jour
     */
    
//    let dailyGoalTitle = [
//        "/\(1)", "/\(18)", "/\(4163)", "/\(3)", "/\(9)"
//    ]
}
