//
//  DocumentariesProvider.swift
//  govegan
//
//  Created by Mosma on 01/06/2021.
//

import UIKit

struct DocumentariesProvider {
    
    // MARK: - Internal properties
    let documentaries: [Documentary] = [
        Documentary(title: "Earthlings", image: UIImage(named: "earthlings"), description: "earthlings".localized, englishVideoID: "3XrY2TP0ZyU", frenchVideoID: "FM_wAN2id58"),
        Documentary(title: "Dominion", image: UIImage(named: "dominion"), description: "dominion".localized, englishVideoID: "LQRAfJyEsko", frenchVideoID: "LQRAfJyEsko"),
        Documentary(title: "why_go_vegan".localized, image: UIImage(named: "earthling-ed"), description: "why_go_vegan_description".localized, englishVideoID: "Z3u7hXpOm58", frenchVideoID: "Z3u7hXpOm58")
    ]
}
