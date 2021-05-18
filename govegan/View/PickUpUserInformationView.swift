//
//  PickUpUserInformationView.swift
//  govegan
//
//  Created by Mosma on 18/05/2021.
//

import Foundation
import UIKit

class PickUpUserInformationView: UIView {
    
    // MARK: - Internal functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Activates the text Field selection
        answerTextField.becomeFirstResponder()
    }
    
    // Load the .xib and add the content view to the view hierarchy
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    // MARK: - IBOutlets
    @IBOutlet var contentView: UIView!
    
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var answerTextField: UITextField!
    @IBOutlet private weak var proceedButton: NextButton!
    @IBOutlet weak var solidLineLabel: UILabel!
    
    // MARK: - IBActions
    
    // MARK: - Private properties
    
    // MARK: - Private functions
    private func initSubviews() {
        
        // Standard initialization logic
        let nib = UINib(nibName: "PickUpUserInformationView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
}

// MARK: - Keyboard
extension PickUpUserInformationView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        answerTextField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 13
        return range.location < maxLength
    }
}
