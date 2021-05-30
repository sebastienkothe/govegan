//
//  AchievementViewController.swift
//  govegan
//
//  Created by Mosma on 27/05/2021.
//

import UIKit

class AchievementViewController: UIViewController {
    
    // MARK: - Internal functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var achievementTableView: UITableView!
    
    // MARK: - IBActions
    
    // MARK: - Private properties
    
    // MARK: - Private functions
}

extension AchievementViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let achievementCell = tableView.dequeueReusableCell(withIdentifier: "AchievementCell", for: indexPath) as? AchievementCell else { return UITableViewCell() }
//        achievementCell.circularProgressView
        
        
        return achievementCell
    }
}

extension AchievementViewController: UITableViewDelegate {}
