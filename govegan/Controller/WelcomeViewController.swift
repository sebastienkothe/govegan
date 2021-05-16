//
//  WelcomeViewController.swift
//  govegan
//
//  Created by Mosma on 15/05/2021.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {
    
    // MARK: - Internal functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(goVeganImageView)
        
        // Assignment of constraints to respective properties
        goVeganImageViewConstraintPreAnimation = goVeganImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        goVeganImageViewConstraintPostAnimation = goVeganImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -150)
        
        setupGoVeganImageViewConstraints()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if user != nil {
            switchLogoGoVeganToTheTop()
        } else {}
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Outlets
    @IBOutlet private weak var welcomeMessagesStackView: UIStackView!
    
    // MARK: - Private properties
    private var goVeganImageViewConstraintPreAnimation: NSLayoutConstraint?
    private var goVeganImageViewConstraintPostAnimation: NSLayoutConstraint?
    
    private let goVeganImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "govegan"))
        
        // This enables autolayout
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// Contains the user who is currently using the app
    private var user = Auth.auth().currentUser
    
    // MARK: - IBActions
    
    /// Starts the performSegue method when the user presses the button
    @IBAction func goButton(_ sender: Any) {
        performSegue(withIdentifier: "segueToAuthenticationViewController", sender: nil)
    }
    
    // MARK: - Private functions
    /// Animates the "govegan" logo by moving it upwards
    private func switchLogoGoVeganToTheTop() {
        UIView.animate(withDuration: 1) { [weak self] in
            
            self?.goVeganImageView.frame.origin.y -= 150
        } completion: { [weak self] _ in
            self?.goVeganImageViewConstraintPostAnimation?.isActive = true
            
            self?.slowlyDisplayWelcomeMessages()
        }
    }
    
    /// Defines the constraints of goVeganImageView
    private func setupGoVeganImageViewConstraints() {
        
        // Gives priority to the constraint that will be displayed last in order to deactivate the first one when the last one is activated
        goVeganImageViewConstraintPreAnimation?.priority = UILayoutPriority(999)
        goVeganImageViewConstraintPreAnimation?.isActive = true
        
        goVeganImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        goVeganImageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        goVeganImageView.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    /// Show welcome messages by changing the opacity of the stackview
    private func slowlyDisplayWelcomeMessages() {
        UIView.animate(withDuration: 1) { [weak self] in
            self?.welcomeMessagesStackView?.alpha = 1.0
        }
    }
}
