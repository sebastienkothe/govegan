//
//  AchievementHeader.swift
//  govegan
//
//  Created by Mosma on 28/05/2021.
//

import UIKit

class AchievementHeader: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal properties
    let title = UILabel()
    
    // MARK: - Internal functions
    func configureContents() {
        title.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(title)
        
        NSLayoutConstraint.activate([
            
            title.heightAnchor.constraint(equalToConstant: 30),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                           constant: 8),
            title.trailingAnchor.constraint(equalTo:
                                                contentView.layoutMarginsGuide.trailingAnchor),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func apply(text: String) {
            title.text = text
        }
}
