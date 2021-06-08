//
//  WelcomeViewController.swift
//  govegan
//
//  Created by Mosma on 15/05/2021.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {
    
    // MARK: - Internal properties
    
    // MARK: - Internal functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: .segueToTabBarFromWelcome, sender: nil)
        }
        
        view.addSubview(goVeganImageView)
        
        setupGoVeganImageViewConstraints()
        setupLoginButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !animationHasBeenShown {
            switchLogoGoVeganToTheTop()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Outlets
    @IBOutlet private weak var welcomeMessagesStackView: UIStackView!
    @IBOutlet private weak var loginButton: UIButton!
    
    // MARK: - IBActions
    
    // MARK: - Private properties
    
    /// Used to know if the animation of the govegan logo has already been used
    private var animationHasBeenShown = false
    
    private let goVeganImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "govegan"))
        
        // This enables autolayout
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Private functions
    
    /// Animates the "govegan" logo by moving it upwards
    private func switchLogoGoVeganToTheTop() {
        UIView.animate(withDuration: 1) { [weak self] in
            self?.goVeganImageView.frame.origin.y -= 150
        } completion: { [weak self] _ in
            self?.animationHasBeenShown = true
            self?.slowlyDisplayWelcomeMessages()
            
            // Update goVeganImageView constraint
            guard let centerYAnchorView = self?.view.centerYAnchor else { return }
            self?.goVeganImageView.centerYAnchor.constraint(equalTo: (centerYAnchorView), constant: -150).isActive = true
        }
    }
    
    /// Defines the constraints of goVeganImageView
    private func setupGoVeganImageViewConstraints() {
        
        // Gives priority to the constraint that will be displayed last in order to deactivate the first one when the last one is activated
        let preAnimationLogoConstraint = goVeganImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        preAnimationLogoConstraint.priority = UILayoutPriority(999)
        preAnimationLogoConstraint.isActive = true
        
        // Constraint for goVeganImageView post animation
        goVeganImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -150).isActive = false
        
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
    
    /// Adds a tapGestureRecognizer and an associated action
    private func setupLoginButton() {
        let loginButtonTap = UITapGestureRecognizer(target: self, action: #selector(didTapOnLoginButton))
        loginButton.addGestureRecognizer(loginButtonTap)
    }
    
    /// User redirection based on their connection status
    @objc private func didTapOnLoginButton(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: .segueToLoginFromWelcome, sender: nil)
    }
}
