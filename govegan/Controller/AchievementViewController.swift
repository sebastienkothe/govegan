//
//  AchievementViewController.swift
//  govegan
//
//  Created by Mosma on 27/05/2021.
//

import UIKit

class AchievementViewController: UIViewController {
    
    // MARK: - Internal properties
    var progressCalculator = ProgressCalculator()
    
    /// Contains the user current progress
    var calculatedProgress: [Double] = [] {
        didSet {
            guard achievementTableView != nil else { return }
            achievementTableView.reloadData()
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var achievementTableView: UITableView!
    
    // MARK: - Private properties
    private let achievementCellElementsProvider = AchievementCellElementsProvider()
}

// MARK: - UITableViewDataSource
extension AchievementViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calculatedProgress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let achievementCell = tableView.dequeueReusableCell(withIdentifier: .achievementCell, for: indexPath) as? AchievementCell else { return UITableViewCell() }
        
        var additionalText = " \(achievementCellElementsProvider.objectiveInformations[indexPath.item])"
        if progressCalculator.objectives[0] > 1 && indexPath.item == 0 { additionalText += "s"}
        
        achievementCell.categoryImageView.image = achievementCellElementsProvider.categoryImages[indexPath.item]
        achievementCell.objectiveLabel.attributedText = progressCalculator.provideComposedText(indexPath.item, additionalText)
        achievementCell.circularProgressView.progressLayer.strokeEnd = progressCalculator.updateProgressLayer(index: indexPath.item, calculatedProgress: calculatedProgress[indexPath.item])
        
        return achievementCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = AchievementHeader()
        header.contentView.backgroundColor = .white
        return header
    }
}

// MARK: - UITableViewDelegate
extension AchievementViewController: UITableViewDelegate {}
