//
//  AuthenticationService.swift
//  govegan
//
//  Created by Mosma on 17/06/2021.
//

import Foundation
import Firebase


protocol AuthProtocol {
    var currentUser: User? { get }
    
    func signOut() throws

    func signIn(withEmail email: String, password: String, completion: ((AuthDataResult?, Error?) -> Void)?)
    
    func createUser(withEmail email: String, password: String, completion: ((AuthDataResult?, Error?) -> Void)?)
}

protocol UserProtocol {
    func delete(completion: ((Error?) -> Void)?)
}

extension User: UserProtocol {}

extension Auth: AuthProtocol { }

enum MockError: Error {
    case error
}

class MockAuth: AuthProtocol {
    var currentUser: User?
    
    func signOut() throws {
        throw MockError.error
    }
    
    func signIn(withEmail email: String, password: String, completion: ((AuthDataResult?, Error?) -> Void)?) {
        completion!(nil, MockError.error)
    }
    
    func createUser(withEmail email: String, password: String, completion: ((AuthDataResult?, Error?) -> Void)?) {
        completion!(nil, MockError.error)
    }
}

class MockAuthSuccessCases: AuthProtocol {
    var currentUser: User?
    
    func signOut() throws {}
    
    func signIn(withEmail email: String, password: String, completion: ((AuthDataResult?, Error?) -> Void)?) {
        completion!(nil, nil)
    }
    
    func createUser(withEmail email: String, password: String, completion: ((AuthDataResult?, Error?) -> Void)?) {
        completion!(nil, nil)
    }
}

protocol AuthenticationDeleterServiceProtocol {
    func deleteUserAuthentication(user: UserProtocol, completion: @escaping (AuthenticationServiceError?) -> Void)
}

class AuthenticationDeleterServiceMock: AuthenticationDeleterServiceProtocol {
    func deleteUserAuthentication(user: UserProtocol, completion: @escaping (AuthenticationServiceError?) -> Void) {
        completion(.unableToDeleteAccount)
    }
}

class AuthenticationDeleterServiceSuccessMock: AuthenticationDeleterServiceProtocol {
    func deleteUserAuthentication(user: UserProtocol, completion: @escaping (AuthenticationServiceError?) -> Void) {
        completion(nil)
    }
}

class AuthenticationDeleterService: AuthenticationDeleterServiceProtocol {
    typealias DeleteUserAuthenticationCompletionHandler = (AuthenticationServiceError?) -> Void
    
    /// Delete user authentication
    func deleteUserAuthentication(user: UserProtocol, completion: @escaping DeleteUserAuthenticationCompletionHandler) {
        user.delete { error in
    
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

class AuthenticationService {

    init(
        auth: AuthProtocol = Auth.auth(),
        authenticationDeleterService: AuthenticationDeleterServiceProtocol = AuthenticationDeleterService()
    ) {
        self.auth = auth
        self.authenticationDeleterService = authenticationDeleterService
    }
    
    // MARK: - Internal properties
    typealias DisconnectUserFromAppCompletionHandler = (Result<Void, AuthenticationServiceError>) -> Void
    typealias ConnectUserWithCompletionHandler = (Result<Void, AuthenticationServiceError>) -> Void
    typealias CreateAccountFromCompletionHandler = (Result<AuthDataResult?, AuthenticationServiceError>) -> Void
    
    // MARK: - Internal functions
    
    /// Remove user authentication
    func deleteUserAuthentication(completion: @escaping (Result<Void, AuthenticationServiceError>) -> Void) {
        
        guard let currentUser = auth.currentUser else {
            completion(.failure(.unableToDeleteAccount))
            return
        }
        
        authenticationDeleterService.deleteUserAuthentication(user: currentUser) { error in
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
    
    /// Try to retrieve the currently logged in user
    func getCurrentUser() -> User?  {
        return auth.currentUser
    }
    
    // MARK: - Private properties
    private let auth: AuthProtocol
    private let authenticationDeleterService: AuthenticationDeleterServiceProtocol
}
