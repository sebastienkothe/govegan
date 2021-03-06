//
//  FirestoreManagerError.swift
//  govegan
//
//  Created by Mosma on 14/06/2021.
//

enum FirestoreManagerError: Error, CaseIterable {
    case unableToCreateAccount
    case unableToRecoverYourAccount
    case noData
    case unableToRemoveUserFromDatabase
    case unableToUpdateData
    
    var title: String {
        switch self {
        case .unableToCreateAccount: return "unable_to_create_account".localized
        case .unableToRecoverYourAccount: return "unable_to_recover_your_account".localized
        case .noData: return "no_data".localized
        case .unableToRemoveUserFromDatabase: return "unable_to_remove_user_from_database".localized
        case .unableToUpdateData: return "unable_to_update_your_data".localized
        }
    }
}
