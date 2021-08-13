//
//  AchievementHeader.swift
//  govegan
//
//  Created by Mosma on 28/05/2021.
//

import UIKit

class AchievementHeader: UITableViewHeaderFooterView {
    
    // MARK: - Internal methods
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Private properties
    private let categoryLabel = UILabel()
    private let goalLabel = UILabel()
    private let progressLabel = UILabel()
    private let stackView = UIStackView()
    
    // MARK: - Private functions
    
    /// Performs the initial configuration of the labels
    private func setupLabel(label: UILabel, text: String, alignement: NSTextAlignment) {
        label.font = UIFont(name: .avenirNext, size: 17)
        label.textColor = #colorLiteral(red: 0.674947679, green: 0.755489707, blue: 0.9283690453, alpha: 1)
        label.text = text
        label.textAlignment = alignement
        stackView.addArrangedSubview(label)
    }
    
    /// Define the constraints of the stack view
    private func definitionOfStackViewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
    
    /// Configure stack view and labels
    private func configureContents() {
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        
        contentView.addSubview(stackView)
        
        definitionOfStackViewConstraints()
        
        setupLabel(label: categoryLabel, text: "category".localized, alignement: .left)
        setupLabel(label: goalLabel, text: "goal".localized, alignement: .center)
        setupLabel(label: progressLabel, text: "progress".localized, alignement: .right)
    }
}
