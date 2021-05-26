//
//  DashboardTabBarController.swift
//  govegan
//
//  Created by Mosma on 23/05/2021.
//

import UIKit

class DashboardTabBarController: UITabBarController {

    // MARK: - Internal properties
    var user: User? = nil
    
    // MARK: - Internal functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Used to pass user data to ProgressViewController
        if let progressViewController = self.viewControllers?.first as? ProgressViewController {
            progressViewController.user = user ?? User(name: "", veganStartDate: "", userID: "", email: "")
        }
    }
}
