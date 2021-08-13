//
//  DocumentaryViewController.swift
//  govegan
//
//  Created by Mosma on 23/05/2021.
//

import UIKit

class DocumentaryViewController: UIViewController {}

// MARK: - UITableViewDataSource
extension DocumentaryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        DocumentariesProvider().documentaries.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let documentaryCell = tableView.dequeueReusableCell(withIdentifier: .documentaryCell, for: indexPath) as? DocumentaryCell else { return UITableViewCell() }
        
        documentaryCell.setup(index: indexPath.section)
        
        return documentaryCell
    }
}

// MARK: - UITableViewDelegate
extension DocumentaryViewController: UITableViewDelegate {}
