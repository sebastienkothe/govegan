//
//  AchievementViewController.swift
//  govegan
//
//  Created by Mosma on 27/05/2021.
//

import UIKit

class AchievementViewController: UIViewController {
    
    // MARK: - Internal properties
    let progressCalculator = ProgressCalculator()
    
    /// Contains the user current progress
    var calculatedProgress: [Double] = [] {
        didSet {
            guard achievementTableView != nil else { return }
            achievementTableView.reloadData()
        }
    }
    
    // MARK: - Internal methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Used to refresh interface with new vegan start date
        NotificationCenter.default.addObserver(self, selector: #selector(cleanObjectives), name: .veganStartDateHasBeenChanged, object: nil)
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var achievementTableView: UITableView!
    
    // MARK: - Private properties
    private let achievements = AchievementsProvider().achievements
    
    // MARK: - Private methods
    
    /// Allows you to set goals after changing the start date
    @objc private func cleanObjectives() {
        progressCalculator.objectives = AchievementsProvider.basicGoals
    }
}

// MARK: - UITableViewDataSource
extension AchievementViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calculatedProgress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let achievementCell = tableView.dequeueReusableCell(withIdentifier: .achievementCell, for: indexPath) as? AchievementCell else { return UITableViewCell() }
        
        var additionalText = " \(achievements[indexPath.item].unitOfMeasure)"
        if progressCalculator.objectives[0] > 1 && indexPath.item == 0 { additionalText += "s"}
        
        achievementCell.categoryImageView.image = achievements[indexPath.item].image
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
