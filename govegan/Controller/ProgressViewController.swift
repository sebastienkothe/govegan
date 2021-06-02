//
//  ProgressViewController.swift
//  govegan
//
//  Created by Mosma on 21/05/2021.
//

import UIKit
import Firebase

class ProgressViewController: UIViewController {
    
    // MARK: - Internal properties
    
    var user = User(name: "", veganStartDate: "", userID: "", email: "")
    let progressCalculator = ProgressCalculator()
    
    // MARK: - Internal functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressCalculator.delegate = self
        //guard let user = self.user else {return}
        user = User(name: "Jean", veganStartDate: "31/05/2021 17:38", userID: "", email: "")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        guard let convertedDate = dateFormatter.date(from: user.veganStartDate) else { return }
        veganStartDate = convertedDate
        
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateUserInterface), userInfo: nil, repeats: true)
    }
    
    // MARK: - IBOutlets
    @IBOutlet var timeLabels: [UILabel]!
    @IBOutlet weak var progressCollectionView: UICollectionView!
    
    // MARK: - IBActions
    
    // MARK: - private properties
    private var veganStartDate = Date()
    private let progressCellElementsProvider = ProgressCellElementsProvider()
    
    private var progressByCategory: [String] = [] {
        didSet {
            progressCollectionView.reloadData()
        }
    }

    // MARK: - private functions
    private func editTheTextOfTimeLabelsFrom(_ timeToDisplay: [String]) {
        timeLabels.forEach({ (timeLabel) in
            timeLabel.text = timeToDisplay[timeLabel.tag]
        })
    }
    
    @objc private func updateUserInterface() {
        let userCalendar = Calendar.current
        
        //Change the seconds to days, hours, minutes and seconds
        let timeElapsed = userCalendar.dateComponents([.year, .day, .hour, .minute, .second], from: veganStartDate, to: Date())
        
        // Manage the time to display
        let timeToDisplay = progressCalculator.checkTheTimeToDisplay(timeElapsed: timeElapsed)
        editTheTextOfTimeLabelsFrom(timeToDisplay)
        
        // Retrieve the user's current progress
        progressByCategory = progressCalculator.calculateTheProgress()
    }
}

// MARK: Data source
extension ProgressViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return progressCellElementsProvider.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let progressCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProgressCell", for: indexPath) as? ProgressCell else { return UICollectionViewCell() }
        
        if !progressByCategory.isEmpty {
            progressCell.counterLabel.text = "\("")\(progressByCategory[indexPath.item])"
        }
        
        progressCell.titleForProgressionLabel.text = progressCellElementsProvider.titleForProgression[indexPath.item]
        progressCell.imageView.image = progressCellElementsProvider.images[indexPath.item]
        
        return progressCell
    }
}

// MARK: Flow layout delegate

extension ProgressViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfColumns: CGFloat = 2
        let width = collectionView.frame.size.width
        let xInsets: CGFloat = 1
        let cellSpacing: CGFloat = 5
        
        return CGSize(width: (width / numberOfColumns) - (xInsets + cellSpacing), height: (width / numberOfColumns) - (xInsets + cellSpacing))
    }
}

extension ProgressViewController: ProgressCalculatorDelegate {
    func progressCanBeUpdated(data: [Double]) {
        let achievementViewController = tabBarController?.viewControllers?[1] as? AchievementViewController
        achievementViewController?.progressCalculated = data
    }
}





