//
//  AuthenticationService+Mock.swift
//  govegan
//
//  Created by Mosma on 09/08/2021.
//

import Firebase

// Used by all mocks
enum MockError: Error {
    case error
}

// MARK: - AuthProtocol
protocol AuthProtocol {
    var currentUser: User? { get }
    
    func signOut() throws
    
    func signIn(withEmail email: String, password: String, completion: ((AuthDataResult?, Error?) -> Void)?)
    
    func createUser(withEmail email: String, password: String, completion: ((AuthDataResult?, Error?) -> Void)?)
    
    func sendPasswordReset(withEmail email: String, completion: ((Error?) -> Void)?)
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
    
    func sendPasswordReset(withEmail email: String, completion: ((Error?) -> Void)?) {
        completion!(MockError.error)
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
    
    func sendPasswordReset(withEmail email: String, completion: ((Error?) -> Void)?) {
        completion!(nil)
    }
}

extension Auth: AuthProtocol { }
