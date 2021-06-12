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
    let progressCalculator = ProgressCalculator()
    
    // MARK: - Internal functions
    private func fetchVeganStartDateFrom(_ userID: String) {
        
        // Get the document based on the user ID
        firestoreManager.getValueFromDocument(userID: userID, valueToReturn: firestoreManager.veganStartDateKey) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let veganStartDate):
                guard let convertedDate = self.progressCalculator.convertDate(veganStartDate) else { return }
                Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateUserInterface(_:)), userInfo: convertedDate, repeats: true)
            case .failure(let error):
                UIAlertService.showAlert(style: .alert, title: "error".localized, message: error.title)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressCalculator.delegate = self
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        fetchVeganStartDateFrom(userID)
    }
    
    // MARK: - IBOutlets
    @IBOutlet var timeLabels: [UILabel]!
    @IBOutlet weak var progressCollectionView: UICollectionView!
    
    // MARK: - IBActions
    
    // MARK: - private properties
    private let progressCellElementsProvider = ProgressCellElementsProvider()
    private let firestoreManager = FirestoreManager.shared
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
    
    @objc private func updateUserInterface(_ timer: Timer) {
        guard let veganStartDate = timer.userInfo as? Date else { return }
        
        //Change the seconds to days, hours, minutes and seconds
        let timeElapsed = Calendar.current.dateComponents([.year, .day, .hour, .minute, .second], from: veganStartDate, to: Date())
        
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
        guard let progressCell = collectionView.dequeueReusableCell(withReuseIdentifier: .progressCell, for: indexPath) as? ProgressCell else { return UICollectionViewCell() }
        
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
        guard let achievementViewController = tabBarController?.viewControllers?[1] as? AchievementViewController else { return }
        achievementViewController.calculatedProgress = data
    }
}





