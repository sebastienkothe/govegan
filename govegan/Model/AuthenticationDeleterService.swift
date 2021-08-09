//
//  AuthenticationDeleterService.swift
//  govegan
//
//  Created by Mosma on 09/08/2021.
//

import Foundation
import Firebase

class AuthenticationDeleterService: AuthenticationDeleterServiceProtocol {
    typealias DeleteUserAuthenticationCompletionHandler = (AuthenticationServiceError?) -> Void
    
    /// Delete user authentication
    func deleteUserAuthentication(user: UserProtocol?, completion: @escaping DeleteUserAuthenticationCompletionHandler) {
        user?.delete { error in
            
            guard error == nil else {
                guard let error = error else { return }
                guard let errorCode = AuthErrorCode(rawValue: error._code) else { return }
                
                if errorCode == .requiresRecentLogin {
                    completion(.logInBeforeDeletingTheAccount)
                    
                } else {
                    completion(.unableToDeleteAccount)
                }
                
                return
            }
            
            completion(nil)
        }
    }
}
