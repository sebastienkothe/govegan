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
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        pickUpUserInformationView.onMainButtonTapped = { [weak self] (userData) in
            
            // Retrieving the controller and changing the value of its "userData" property
            let storyBoard = UIStoryboard(name: .mainStoryboard, bundle: nil)
            guard let viewController =  storyBoard.instantiateViewController(withIdentifier: .signUpViewController) as? SignUpViewController else { return }
            viewController.userData = userData
            
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
        
        pickUpUserInformationView.backButtonTapped = { [weak self] in
            
            //Go back to previous controller
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var pickUpUserInformationView: PickUpUserInformationView!
    
    /// Allows you to close the keyboard
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
}
