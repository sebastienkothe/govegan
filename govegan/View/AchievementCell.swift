//
//  AchievementCell.swift
//  govegan
//
//  Created by Mosma on 28/05/2021.
//

import UIKit

class AchievementCell: UITableViewCell {
    
    // MARK: - Internal functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var circularProgressView: AchievementCircularProgressView!
    
    
    // MARK: - IBActions
    
    // MARK: - Private properties
    
    // MARK: - Private functions
}
