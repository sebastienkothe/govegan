//
//  ChangeStartDateController.swift
//  govegan
//
//  Created by Mosma on 11/08/2021.
//

import UIKit

class ChangeStartDateController: UIViewController {
    
    // MARK: - Internal methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var veganStartDateLbl: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // MARK: - IBActions
    @IBAction func backBtnTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func datePickerTouched(_ sender: UIDatePicker) {
        print("Touched")
    }
    
    @IBAction func sendBtnTapped(_ sender: UIButton) {
    }
    
    // MARK: - Private properties
    private var currentDate = Date()
    
    // MARK: - Private methods
    private func setupDatePicker() {
        datePicker.date = currentDate
    }
}
