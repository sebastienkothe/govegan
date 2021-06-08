//
//  AchievementViewController.swift
//  govegan
//
//  Created by Mosma on 27/05/2021.
//

import UIKit

class AchievementViewController: UIViewController {
    
    // MARK: - Internal properties
    
    /// Contains the user current progress
    var progressCalculated: [Double] = [] {
        didSet {
            guard achievementTableView != nil else { return }
            achievementTableView.reloadData()
        }
    }
    
    // MARK: - Internal functions
    
    // MARK: - IBOutlets
    @IBOutlet weak var achievementTableView: UITableView!
    
    // MARK: - IBActions
    
    // MARK: - Private properties
    private let achievementCellElementsProvider = AchievementCellElementsProvider()
    private var objectives: [Double] = [1, 20, 4500, 10, 35]
    
    // MARK: - Private functions
    
    /// Allows you to edit the text for the goal
    private func setupTextForCells(_ text: NSMutableAttributedString, _ indexPath: IndexPath, _ additionalText: String) {
        guard let avenirNextFont = UIFont(name: .avenirNext, size: 17) else { return }
        
        let firstPartOfTheText = String(format: "%.\(String(0))f", objectives[indexPath.item].rounded(.towardZero))
        let attributesForAdditionalText = [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: avenirNextFont]
        
        text.append(NSAttributedString(string: firstPartOfTheText, attributes: [:]))
        text.append(NSAttributedString(string: additionalText, attributes: attributesForAdditionalText))
    }
}

extension AchievementViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return progressCalculated.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let achievementCell = tableView.dequeueReusableCell(withIdentifier: .achievementCell, for: indexPath) as? AchievementCell else { return UITableViewCell() }
        
        var additionalText = " \(achievementCellElementsProvider.objectiveInformations[indexPath.item])"
        if objectives[0] > 1 && indexPath.item == 0 { additionalText += "s"}
        let text = NSMutableAttributedString()
        
        setupTextForCells(text, indexPath, additionalText)
        
        let objective = objectives[indexPath.item]
        let calculatedProgress = progressCalculated[indexPath.item]
        
        if calculatedProgress > objective  {
            objectives[indexPath.item] = ceil(objective * 1.3)
        }
        
        let testProgrogress = CGFloat(1 / (objective / calculatedProgress))
        //let currentProgress = CGFloat(1 - (objective - calculatedProgress) / objective)
        
        achievementCell.categoryImageView.image = achievementCellElementsProvider.categoryImages[indexPath.item]
        achievementCell.objectiveLabel.attributedText = text
        achievementCell.circularProgressView.progressLayer.strokeEnd = testProgrogress
        
        return achievementCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = AchievementHeader()
        header.contentView.backgroundColor = .white
        return header
    }
}

extension AchievementViewController: UITableViewDelegate {}
