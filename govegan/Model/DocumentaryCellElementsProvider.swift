//
//  DocumentaryCellElementsProvider.swift
//  govegan
//
//  Created by Mosma on 01/06/2021.
//

import UIKit

struct DocumentaryCellElementsProvider {
    let titles = [
        "Earthlings",
        "Dominion",
        "why_go_vegan".localized
    ]
    
    let images: [UIImage?] = [
        UIImage(named: "earthlings"), UIImage(named: "dominion"), UIImage(named: "earthling-ed")
    ]
    
    let description = [
        "earthlings".localized,
        "dominion".localized,
        "why_go_vegan_description".localized
    ]
    
    let englishVideoID = [
        "3XrY2TP0ZyU", "LQRAfJyEsko", "Z3u7hXpOm58"
    ]
    
    let frenchVideoID = [
        "FM_wAN2id58", "LQRAfJyEsko", "Z3u7hXpOm58"
    ]
}
