//
//  AuthenticationService+Mock.swift
//  govegan
//
//  Created by Mosma on 09/08/2021.
//

import Foundation
import Firebase

protocol AuthProtocol {
    var currentUser: User? { get }
    
    func signOut() throws

    func signIn(withEmail email: String, password: String, completion: ((AuthDataResult?, Error?) -> Void)?)
    
    func createUser(withEmail email: String, password: String, completion: ((AuthDataResult?, Error?) -> Void)?)
}

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
