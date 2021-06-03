//
//  LoginButton.swift
//  govegan
//
//  Created by Mosma on 02/06/2021.
//

import UIKit

class LoginButton: UIButton {
    
    // MARK: - Internal functions
    override func awakeFromNib() {
        super.awakeFromNib()
        roundedCorner()
    }
    
    // MARK: - Private functions
    
    private func roundedCorner() {
        self.layer.cornerRadius = 10
    }
}
