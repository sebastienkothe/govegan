//
//  WelcomeViewController.swift
//  govegan
//
//  Created by Mosma on 15/05/2021.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    // MARK: - Internal functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Redirection management based on connection status
        
        if authenticationService.getCurrentUser() != nil {
            performSegue(withIdentifier: .segueToTabBarFromWelcome, sender: nil)
        }
        
        setupLoginButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Animates the logo under condition
        if !animationHasBeenShown { switchLogoGoVeganToTheTop() }
    }
    
    // MARK: - Outlets
    @IBOutlet private weak var welcomeMessagesStackView: UIStackView!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet weak var goVeganLogo: UIImageView!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var footerStackView: UIStackView!
    
    // MARK: - Private properties
    
    /// Used to know if the animation of the govegan logo has already been used
    private var animationHasBeenShown = false
    private let authenticationService = AuthenticationService()
    
    // MARK: - Private functions
    
    /// Animates the "govegan" logo by moving it upwards
    private func switchLogoGoVeganToTheTop() {
        UIView.animate(withDuration: 1, delay: 1) { [weak self] in
            self?.goVeganLogo.frame.origin.y -= 150
        } completion: { [weak self] _ in
            self?.animationHasBeenShown = true
            self?.slowlyDisplayWelcomeMessages()
            
            // Update goVeganImageView constraint
            guard let centerYAnchorView = self?.view.centerYAnchor else { return }
            self?.goVeganLogo.centerYAnchor.constraint(equalTo: (centerYAnchorView), constant: -150).isActive = true
        }
    }
    
    /// Show welcome messages by changing the opacity of the stackview
    private func slowlyDisplayWelcomeMessages() {
        UIView.animate(withDuration: 1) { [weak self] in
            guard let self = self else { return }
            for subview in self.view.subviews where subview.tag == 1 {
                subview.alpha = 1.0
            }
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
