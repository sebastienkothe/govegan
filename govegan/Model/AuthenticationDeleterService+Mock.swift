//
//  AuthenticationDeleterService+Mock.swift
//  govegan
//
//  Created by Mosma on 09/08/2021.
//

import Firebase

// MARK: - UserProtocol
protocol UserProtocol {
    func delete(completion: ((Error?) -> Void)?)
}

class UserMock: UserProtocol {
    func delete(completion: ((Error?) -> Void)?) {
        completion!(MockError.error)
    }
}

class UserErrorRefreshLoginMock: UserProtocol {
    func delete(completion: ((Error?) -> Void)?) {
        completion!(AuthErrorCode(rawValue: 17014))
    }
}

class UserSuccessMock: UserProtocol {
    func delete(completion: ((Error?) -> Void)?) {
        completion!(nil)
    }
}

extension User: UserProtocol {}
extension AuthErrorCode: Error {}


// MARK: - AuthenticationDeleterServiceProtocol
protocol AuthenticationDeleterServiceProtocol {
    func deleteUserAuthentication(user: UserProtocol?, completion: @escaping (AuthenticationServiceError?) -> Void)
}

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
