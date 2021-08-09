//
//  AuthenticationDeleterService+Mock.swift
//  govegan
//
//  Created by Mosma on 09/08/2021.
//

import Foundation
import Firebase

protocol UserProtocol {
    func delete(completion: ((Error?) -> Void)?)
}

protocol AuthenticationDeleterServiceProtocol {
    func deleteUserAuthentication(user: UserProtocol?, completion: @escaping (AuthenticationServiceError?) -> Void)
}

extension User: UserProtocol {}

class AuthenticationDeleterServiceMock: AuthenticationDeleterServiceProtocol {
    func deleteUserAuthentication(user: UserProtocol?, completion: @escaping (AuthenticationServiceError?) -> Void) {
        completion(.unableToDeleteAccount)
    }
}

class AuthenticationDeleterServiceSuccessMock: AuthenticationDeleterServiceProtocol {
    func deleteUserAuthentication(user: UserProtocol?, completion: @escaping (AuthenticationServiceError?) -> Void) {
        completion(nil)
    }
}
