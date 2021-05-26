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
    
    // MARK: - Internal functions
    override func viewDidLoad() {
        super.viewDidLoad()
        //guard let user = self.user else {return}
        
        user = User(name: "Jean", veganStartDate: "26/05/2021 09:00", userID: "", email: "")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        guard let convertedDate = dateFormatter.date(from: user.veganStartDate) else { return }
        veganStartDate = convertedDate
        
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateUserInterface), userInfo: nil, repeats: true)
    }
    
    // MARK: - IBOutlets
    @IBOutlet var timeLabels: [UILabel]!
    
    // MARK: - IBActions
    
    // MARK: - private properties
    private var veganStartDate = Date()
    private let progressCalculator = ProgressCalculator()
    private let progressCellElementsProvider = ProgressCellElementsProvider()
    private var counterLabels: [UILabel] = []
    
    // MARK: - private functions
    
    private func editTheTextOfTimeLabelsFrom(_ timeToDisplay: [String]) {
        timeLabels.forEach({ (timeLabel) in
            timeLabel.text = timeToDisplay[timeLabel.tag]
        })
    }
    
    @objc func updateUserInterface() {
        let userCalendar = Calendar.current
        
        //Change the seconds to days, hours, minutes and seconds
        let timeElapsed = userCalendar.dateComponents([.year, .day, .hour, .minute, .second], from: veganStartDate, to: Date())
        
        let timeToDisplay = progressCalculator.checkTheTimeToDisplay(timeElapsed: timeElapsed)
        editTheTextOfTimeLabelsFrom(timeToDisplay)
        
        counterLabels.forEach( {(counterLabel) in
            counterLabel.text = "\("")\(progressCellElementsProvider.dailyGoalTitle[counterLabel.tag])"
        })
    }
}

// MARK: Data source
extension ProgressViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return progressCellElementsProvider.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let progressCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProgressCell", for: indexPath) as? ProgressCell else { return UICollectionViewCell() }
        
        progressCell.setupShadowView()
        progressCell.counterLabel.tag = indexPath.item
        
        counterLabels.append(progressCell.counterLabel)
        
        let image = progressCellElementsProvider.images[indexPath.item]
        let titleForProgression = progressCellElementsProvider.titleForProgression[indexPath.item]
        
        //let dailyGoalTitle = progressCellElementsProvider.dailyGoalTitle[indexPath.item]
        
        progressCell.titleForProgressionLabel.text = titleForProgression
        progressCell.imageView.image = image
        //progressCell.counterLabel.text = dailyGoalTitle
        
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





