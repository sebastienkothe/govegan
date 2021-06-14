//
//  FirestoreManagerError.swift
//  govegan
//
//  Created by Mosma on 14/06/2021.
//

import Foundation

enum FirestoreManagerError: Error, CaseIterable {
    case unableToCreateAccount
    case unableToRecoverYourAccount
    case noData
    
    var title: String {
        switch self {
        case .unableToCreateAccount: return "unable_to_create_account".localized
        case .unableToRecoverYourAccount: return "unable_to_recover_your_account".localized
        case .noData: return "no_data".localized
        }
    }
}
