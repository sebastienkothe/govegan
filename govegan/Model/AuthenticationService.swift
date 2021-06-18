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
    var deleteADocumentReturnedAnError: ((FirestoreManagerError) -> Void)?
    
    typealias DeleteUserAuthenticationCompletionHandler = (AuthenticationServiceError?) -> Void
    typealias DisconnectUserFromAppCompletionHandler = (AuthenticationServiceError?) -> Void
    typealias DeleteUserFromDatabaseCompletionHandler = (FirestoreManagerError?) -> Void
    // MARK: - Internal functions
    
    /// Delete user authentication
    func deleteUserAuthentication(completion: @escaping DeleteUserAuthenticationCompletionHandler) {
        Auth.auth().currentUser?.delete { error in
            
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
    
    func deleteUserFromDatabase(completion: @escaping DeleteUserFromDatabaseCompletionHandler) {
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        /// Delete firestore entry
        self.firestoreManager.deleteADocument(userID: userID) { error in
            
            guard error == nil else {
                completion(error)
                return
            }
        }
    }
    
    // MARK: - Private properties
    private let firestoreManager = FirestoreManager.shared
}
