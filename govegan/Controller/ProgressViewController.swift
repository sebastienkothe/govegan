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
    
    // MARK: - Internal functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var progressCollectionView: UICollectionView!
    
    
    // MARK: - IBActions
    @IBAction private func didTapOnSignOutButton() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    // MARK: - private properties
    private let progressCellElementsProvider = ProgressCellElementsProvider()
    
    // MARK: - private functions
}

// MARK: Data source
extension ProgressViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return progressCellElementsProvider.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let progressCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProgressCell", for: indexPath) as? ProgressCell else { return UICollectionViewCell() }
        
//        if indexPath.item == 0 {
//            progressCell.titleForProgressionLabel.font = UIFont(name: "Avenir Next", size: 21)
//            progressCell.counterLabel.font = UIFont.systemFont(ofSize: 31, weight: .heavy)
//        }
        
        let image = progressCellElementsProvider.images[indexPath.item]
        let text = progressCellElementsProvider.titleForProgression[indexPath.item]
        
        progressCell.titleForProgressionLabel.text = text
        progressCell.imageView.image = image
        return progressCell
    }
}

// MARK: Flow layout delegate

extension ProgressViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumns: CGFloat = 2
        let width = collectionView.frame.size.width
        let xInsets: CGFloat = 10
        let cellSpacing: CGFloat = 5
        
        return CGSize(width: (width / numberOfColumns) - (xInsets + cellSpacing), height: (width / numberOfColumns) - (xInsets + cellSpacing))
    }
    
}


