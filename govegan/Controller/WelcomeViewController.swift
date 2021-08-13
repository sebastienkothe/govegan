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
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Animates the logo under condition
        if !animationHasBeenShown { switchLogoGoVeganToTheTop() }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var goVeganLogo: UIImageView!
    @IBOutlet weak var goVeganLogoCenterYConstraint: NSLayoutConstraint!
    
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
            self?.goVeganLogoCenterYConstraint.constant = -150
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
}
