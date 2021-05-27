//
//  NameRequestViewController.swift
//  govegan
//
//  Created by Mosma on 18/05/2021.
//

import UIKit

class NameRequestViewController: UIViewController {

    // MARK: - Internal functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        backButton.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - IBOutlets
    @IBOutlet private weak var backButton: BackButton!
    
    // MARK: - IBActions
    @IBAction func didTapOnBackButton(_ sender: Any) {
        
        //Go back to previous controller
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private properties
    
    // MARK: - Private functions
    
    //Calls this function when the tap is recognized.
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
