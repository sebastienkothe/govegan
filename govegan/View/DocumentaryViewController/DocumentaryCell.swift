//
//  DocumentaryCell.swift
//  govegan
//
//  Created by Mosma on 31/05/2021.
//

import UIKit

class DocumentaryCell: UITableViewCell {
    
    // MARK: - Internal properties
    
    // MARK: - Internal functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = #colorLiteral(red: 0.674947679, green: 0.755489707, blue: 0.9283690453, alpha: 0.2065405435)
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 10
        selectedBackgroundView = backgroundView
        
        documentaryImage.translatesAutoresizingMaskIntoConstraints = false
        documentaryImage.heightAnchor.constraint(equalTo: documentaryImage.widthAnchor).isActive = true
    }

    // MARK: - IBOutlets
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var documentaryImage: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    
    // MARK: - IBActions
    @IBAction func didTapOnWatchButton() {
        var videos = documentaryCellElementsProvider.englishVideoID
        
        let language = NSLocale.preferredLanguages[0]
        if language == "fr-FR" { videos = documentaryCellElementsProvider.frenchVideoID }
        
        watchVideoFrom(youtubeID: videos[tag])
    }
    
    // MARK: - Private properties
    private let documentaryCellElementsProvider = DocumentaryCellElementsProvider()
    
    // MARK: - Private functions
    /// Used to open youtube video
    private func watchVideoFrom(youtubeID: String) {
        
        guard let localYoutubeUrl = URL(string:"youtube://\(youtubeID)"),
              let browserYoutubeUrl = URL(string:"http://www.youtube.com/watch?v=\(youtubeID)")
        else { return }
        
        let youtubeUrl = UIApplication.shared.canOpenURL(localYoutubeUrl) ?
            localYoutubeUrl : browserYoutubeUrl
        
        UIApplication.shared.open(youtubeUrl, options: [:], completionHandler: nil)
    }
}
