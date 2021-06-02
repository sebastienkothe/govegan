//
//  DocumentaryViewController.swift
//  govegan
//
//  Created by Mosma on 23/05/2021.
//

import UIKit

class DocumentaryViewController: UIViewController {
    
    // MARK: - Internal properties
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Internal functions
    
    // MARK: - IBOutlets
    @IBOutlet weak var documentaryTableView: UITableView!
    
    // MARK: - IBActions
    
    // MARK: - private properties
    //    private var veganNewsResponse: VeganNewsResponse? {
    //        didSet {
    //            documentaryTableView.reloadData()
    //        }
    //    }
    
    private let documentaryCellElementsProvider = DocumentaryCellElementsProvider()
    // MARK: - private functions
    //    private func searchForVeganNews() {
    //        let language = "fr"
    //
    //        veganNewsNetworkManager.fetchVeganNewsFor(language, completion: { [weak self] (result) in
    //            guard let self = self else { return }
    //
    //            DispatchQueue.main.async {
    //                switch result {
    //                case .success(let veganNewsResponse):
    //                    self.veganNewsResponse = veganNewsResponse
    //                case .failure(let error):
    //                    self.handleLinkOpeningAltert(error: error)
    //                }
    //            }
    //        })
    //    }
    
    //    /// Used to hide/show items
    //    private func handleActivityIndicator(shown: Bool, activityIndicator: UIActivityIndicatorView, button: UIButton) {
    //        shown ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    //        button.isHidden = shown
    //    }
    //
    
    /// Used to handle errors from the viewcontrollers
    private func handleLinkOpeningAltert(youtubeID: String, videoTitle: String) {
        let alert = UIAlertController(title: videoTitle, message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil)
        
        let okay = UIAlertAction(title: "let_it_go".localized, style: .default) { _ in
            
            guard var url = URL(string:"youtube://\(youtubeID)") else { return }
            if !UIApplication.shared.canOpenURL(url)  {
                url = URL(string:"http://www.youtube.com/watch?v=\(youtubeID)")!
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
        let okayColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let cancelColor: UIColor = #colorLiteral(red: 0.4980392157, green: 0.1450980392, blue: 0.1176470588, alpha: 1)
        
        okay.setValue(okayColor, forKey: "titleTextColor")
        cancel.setValue(cancelColor, forKey: "titleTextColor")
        
        alert.addAction(okay)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}

extension DocumentaryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        documentaryCellElementsProvider.images.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        guard let numberOfArticles = veganNewsResponse?.articles.count else { return 0 }
        return 1
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let documentaryCell = tableView.dequeueReusableCell(withIdentifier: "DocumentaryCell", for: indexPath) as? DocumentaryCell else { return UITableViewCell() }
        
        documentaryCell.documentaryImage.image = documentaryCellElementsProvider.images[indexPath.section]
        documentaryCell.title.text = documentaryCellElementsProvider.titles[indexPath.section]
        documentaryCell.contentLabel.text = documentaryCellElementsProvider.description[indexPath.section]
        
        return documentaryCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var videos = documentaryCellElementsProvider.englishVideoID
        
        let language = NSLocale.preferredLanguages[0]
        if language == "fr-FR" { videos = documentaryCellElementsProvider.frenchVideoID }
        
        guard let currentCell = tableView.cellForRow(at: indexPath) as? DocumentaryCell else { return }
        guard let title = currentCell.title.text else { return }
        
        handleLinkOpeningAltert(youtubeID: videos[indexPath.section], videoTitle: "watch".localized + "\"\(title)\"" + " ?")
    }
}

extension DocumentaryViewController: UITableViewDelegate {}
