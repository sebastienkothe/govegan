//
//  BackButton.swift
//  govegan
//
//  Created by Mosma on 17/05/2021.
//

import Foundation
import UIKit

class BackButton: UIButton {
    
    // MARK: - Internal functions
    func setup() {
        self.layer.masksToBounds = true
        self.setTitle("Back", for: .normal)
        self.setTitleColor(.gray, for: .normal)
    }
}
