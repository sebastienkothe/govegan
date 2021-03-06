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
        setup()
    }
    
    // MARK: - Private functions
    private func setup() {
        layer.cornerRadius = 10
        setTitle("send".localized, for: .normal)
    }
}
