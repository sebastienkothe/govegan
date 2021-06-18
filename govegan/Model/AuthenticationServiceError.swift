//
//  AuthenticationServiceError.swift
//  govegan
//
//  Created by Mosma on 17/06/2021.
//

import Foundation

enum AuthenticationServiceError: Error, CaseIterable {
    case logInBeforeDeletingTheAccount
    case unableToDeleteAccount
    case unableToLogOut
    case unableToConnectUser
    case unableToCreateAccount
    
    var title: String {
        switch self {
        case .logInBeforeDeletingTheAccount: return "log_in_before_deleting_the_account".localized
        case .unableToDeleteAccount: return "unable_to_delete_account".localized
        case .unableToLogOut: return "unable_to_log_out".localized
        case .unableToConnectUser: return "unable_to_connect_user".localized
        case .unableToCreateAccount: return "unable_to_create_account".localized
        }
    }
}
