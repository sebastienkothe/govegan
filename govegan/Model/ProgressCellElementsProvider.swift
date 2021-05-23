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
        UIImage(named: "clock"), UIImage(named: "heart"), UIImage(named: "wheat"), UIImage(named: "water"), UIImage(named: "evergreen"), UIImage(named: "cloud")
        ]
    
    let titleForProgression = [
        "vegan_since".localized, "animal_lives".localized, "kg_of_grain".localized, "litres_of_water".localized, "sqm_of_forest".localized, "kg_of_co2".localized
    ]
}
