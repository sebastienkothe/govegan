//
//  DocumentaryCell.swift
//  govegan
//
//  Created by Mosma on 31/05/2021.
//

import UIKit

class DocumentaryCell: UITableViewCell {
    
    // MARK: - Internal functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = #colorLiteral(red: 0.674947679, green: 0.755489707, blue: 0.9283690453, alpha: 0.2065405435)
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 10
        selectedBackgroundView = backgroundView
        
        documentaryImage.translatesAutoresizingMaskIntoConstraints = false
        documentaryImage.heightAnchor.constraint(equalTo: documentaryImage.widthAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var documentaryImage: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
}
