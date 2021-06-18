//
//  AuthenticationService.swift
//  govegan
//
//  Created by Mosma on 17/06/2021.
//

import Foundation
import Firebase

class AuthenticationService {
    
    // MARK: - Internal properties
    
    typealias DeleteUserAuthenticationCompletionHandler = (AuthenticationServiceError?) -> Void
    typealias DisconnectUserFromAppCompletionHandler = (AuthenticationServiceError?) -> Void
    typealias DeleteUserFromDatabaseCompletionHandler = (FirestoreManagerError?) -> Void
    typealias ConnectUserWithCompletionHandler = (AuthenticationServiceError?) -> Void
    typealias CreateAccountFromCompletionHandler = (Result<AuthDataResult?, AuthenticationServiceError>) -> Void
    
    // MARK: - Internal functions
    
    /// Delete user authentication
    func deleteUserAuthentication(completion: @escaping DeleteUserAuthenticationCompletionHandler) {
        getCurrentUser()?.delete { error in
            
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
    
    /// Try to log the user out of the app
    func disconnectUserFromApp(completion: @escaping DisconnectUserFromAppCompletionHandler) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch {
            completion(.unableToLogOut)
        }
    }
    
    /// Delete user's data
    func deleteUserFromDatabase(completion: @escaping DeleteUserFromDatabaseCompletionHandler) {
        
        guard let userID = getCurrentUser()?.uid else { return }
        
        /// Delete firestore entry
        self.firestoreManager.deleteADocument(userID: userID) { error in
            guard error == nil else {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
    
    /// Allows the user to connect with his email address and password
    func connectUserWith(_ email: String, and password: String, completion: @escaping ConnectUserWithCompletionHandler) {
        Auth.auth().signIn(withEmail: email, password: password) { _ , error in
            guard error == nil else {
                completion(.unableToConnectUser)
                return
            }
            
            completion(nil)
        }
    }
    
    /// Used to create an account
    func createAccountFrom(_ email: String, _ password: String, completion: @escaping CreateAccountFromCompletionHandler) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            guard error == nil else {
                completion(.failure(.unableToCreateAccount))
                return
            }
            
            completion(.success(result))
        }
    }
    
    /// Try to retrieve the currently logged in user
    func getCurrentUser() -> User?  {
        return Auth.auth().currentUser
    }
    
    // MARK: - Private properties
    private let firestoreManager = FirestoreManager.shared
}
