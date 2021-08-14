//
//  AuthenticationService.swift
//  govegan
//
//  Created by Mosma on 17/06/2021.
//

import Firebase

class AuthenticationService {
    
    // MARK: - Initializer
    init(auth: AuthProtocol = Auth.auth(),
         authenticationDeleterService: AuthenticationDeleterServiceProtocol = AuthenticationDeleterService()) {
        self.auth = auth
        self.authenticationDeleterService = authenticationDeleterService
    }
    
    // MARK: - Internal properties
    typealias DisconnectUserFromAppCompletionHandler = (Result<Void, AuthenticationServiceError>) -> Void
    typealias ConnectUserWithCompletionHandler = (Result<Void, AuthenticationServiceError>) -> Void
    typealias CreateAccountFromCompletionHandler = (Result<AuthDataResult?, AuthenticationServiceError>) -> Void
    typealias ResetPasswordCompletionHandler = (Result<Void, AuthenticationServiceError>) -> Void
    
    // MARK: - Internal functions
    
    /// Remove user authentication
    func deleteUserAuthentication(completion: @escaping (Result<Void, AuthenticationServiceError>) -> Void) {
        
        authenticationDeleterService.deleteUserAuthentication(user: auth.currentUser) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
    }
    
    /// Try to log the user out of the app
    func disconnectUserFromApp(completion: @escaping DisconnectUserFromAppCompletionHandler) {
        do {
            try auth.signOut()
            completion(.success(()))
        } catch {
            completion(.failure(.unableToLogOut))
        }
    }
    
    /// Allows the user to connect with his email address and password
    func connectUserWith(_ email: String, and password: String, completion: @escaping ConnectUserWithCompletionHandler) {
        auth.signIn(withEmail: email, password: password) { _ , error in
            guard error == nil else {
                completion(.failure(.unableToConnectUser))
                return
            }
            
            completion(.success(()))
        }
    }
    
    /// Used to create an account
    func createAccountFrom(_ email: String, _ password: String, completion: @escaping CreateAccountFromCompletionHandler) {
        auth.createUser(withEmail: email, password: password) { result, error in
            
            guard error == nil else {
                completion(.failure(.unableToCreateAccount))
                return
            }
            
            completion(.success(result))
        }
    }
    
    /// Used to reset user's password
    func resetPassword(email: String, completion: @escaping ResetPasswordCompletionHandler) {
        auth.sendPasswordReset(withEmail: email) { error in
            guard error == nil else {
                completion(.failure(.unableToResetPassword))
                return
            }
            
            completion(.success(()))
        }
    }
    
    /// Try to retrieve the currently logged in user
    func getCurrentUser() -> User?  {
        return auth.currentUser
    }
    
    // MARK: - Private properties
    private let auth: AuthProtocol
    private let authenticationDeleterService: AuthenticationDeleterServiceProtocol
}
