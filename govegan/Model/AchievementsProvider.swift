//
//  AchievementCellElementsProvider.swift
//  govegan
//
//  Created by Mosma on 28/05/2021.
//

import Foundation
import UIKit

struct AchievementsProvider {
    
    // MARK: - Internal properties
    static let basicGoals: [Double] = [1, 20, 4500, 10, 35]
    
    let achievements: [Achievement] = [
        Achievement(image: UIImage(named: "pig-80"), unitOfMeasure: "life".localized),
        Achievement(image: UIImage(named: "barley-80"), unitOfMeasure: "kg"),
        Achievement(image: UIImage(named: "water-80"), unitOfMeasure: "l"),
        Achievement(image: UIImage(named: "tree-80"), unitOfMeasure: "sqm".localized),
        Achievement(image: UIImage(named: "co2-80"), unitOfMeasure: "kg")
        
    ]
}
