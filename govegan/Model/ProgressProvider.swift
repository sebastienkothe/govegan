//
//  ProgressCellElementsProvider.swift
//  govegan
//
//  Created by Mosma on 22/05/2021.
//

import Foundation
import UIKit

struct ProgressProvider {
    
    // MARK: - Internal properties
    let progress: [Progress] = [
        Progress(title: "animal_lives".localized, image: UIImage(named: "heart")), Progress(title: "kg_of_grain".localized, image: UIImage(named: "wheat")), Progress(title: "litres_of_water".localized, image: UIImage(named: "water")), Progress(title: "sqm_of_forest".localized, image: UIImage(named: "evergreen")), Progress(title: "kg_of_co2".localized, image: UIImage(named: "cloud"))
    ]
}
