//
//  NextButton.swift
//  govegan
//
//  Created by Mosma on 18/05/2021.
//

import Foundation
import UIKit

class NextButton: UIButton {
    
    // MARK: - Internal functions
    override func awakeFromNib() {
        super.awakeFromNib()
        roundedCorner()
    }
    
    // MARK: - Private functions
    private func roundedCorner() {
        self.layer.cornerRadius = self.frame.height / 2
    }
}
