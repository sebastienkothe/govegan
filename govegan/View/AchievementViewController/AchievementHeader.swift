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
    let categoryLabel = UILabel()
    let goalLabel = UILabel()
    let progressLabel = UILabel()
    let stackView = UIStackView()
    
    // MARK: - Internal functions
    func configureContents() {
        
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        goalLabel.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        setupLabel(label: categoryLabel, text: "category".localized, alignement: .left)
        setupLabel(label: goalLabel, text: "goal".localized, alignement: .center)
        setupLabel(label: progressLabel, text: "progress".localized, alignement: .right)
    }
    
    // MARK: - Private properties
    
    // MARK: - Private functions
    private func setupLabel(label: UILabel, text: String, alignement: NSTextAlignment) {
        label.font = UIFont(name: "Avenir Next", size: 17)
        label.textColor = #colorLiteral(red: 0.674947679, green: 0.755489707, blue: 0.9283690453, alpha: 1)
        label.text = text
        label.textAlignment = alignement
        stackView.addArrangedSubview(label)
    }
}
