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
    override class func awakeFromNib() {
        super.awakeFromNib()
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
    func setupShadowView() {
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowRadius = 10
    }
}
