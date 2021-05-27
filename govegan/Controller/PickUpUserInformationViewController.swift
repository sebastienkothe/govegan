//
//  PickUpUserInformationViewController.swift
//  govegan
//
//  Created by Mosma on 18/05/2021.
//

import UIKit

class PickUpUserInformationViewController: UIViewController {
    
    // MARK: - Internal functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        pickUpUserInformationView.onMainButtonTapped = { [weak self] (userData) in
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let viewController =  storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            viewController.userData = userData
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
        
        pickUpUserInformationView.backButtonTapped = { [weak self] in
            
            //Go back to previous controller
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var pickUpUserInformationView: PickUpUserInformationView!
    
    // MARK: - Private function
    
    /// Allows you to close the keyboard
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}