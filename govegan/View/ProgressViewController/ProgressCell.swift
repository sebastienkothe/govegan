//
//  ProgressCell.swift
//  govegan
//
//  Created by Mosma on 22/05/2021.
//

import UIKit

class ProgressCell: UICollectionViewCell {
    
    // MARK: - Internal properties
    
    // MARK: - Internal functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupShadow()
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleForProgressionLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var progressStackView: UIStackView!
    @IBOutlet weak var shadowView: UIView!
    
    // MARK: - IBActions
    
    // MARK: - Private properties
    
    // MARK: - Private functions
    private func setupShadow() {
        self.layer.shadowColor = #colorLiteral(red: 0.674947679, green: 0.755489707, blue: 0.9283690453, alpha: 1)
        self.layer.shadowOffset = CGSize(width: 8.0, height: 8.0)
        self.layer.shadowOpacity = 0.3
    }
}
