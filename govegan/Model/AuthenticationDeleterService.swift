//
//  AuthenticationDeleterService.swift
//  govegan
//
//  Created by Mosma on 09/08/2021.
//

import Firebase

class AuthenticationDeleterService: AuthenticationDeleterServiceProtocol {
    typealias DeleteUserAuthenticationCompletionHandler = (AuthenticationServiceError?) -> Void
    
    /// Delete user authentication
    func deleteUserAuthentication(user: UserProtocol?, completion: @escaping DeleteUserAuthenticationCompletionHandler) {
        user?.delete { error in
            
            if let error = error {
                AuthErrorCode(rawValue: error._code) == .requiresRecentLogin ? completion(.logInBeforeDeletingTheAccount) :  completion(.unableToDeleteAccount)
                return
            }
            
            completion(nil)
        }
    }
}
