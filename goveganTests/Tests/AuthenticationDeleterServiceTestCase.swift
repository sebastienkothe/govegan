//
//  AuthenticationDeleterServiceTestCase.swift
//  goveganTests
//
//  Created by Mosma on 14/08/2021.
//

import XCTest
import Firebase

@testable import govegan

class AuthenticationDeleterServiceTestCase: XCTestCase {
    
    var authenticationDeleterService: AuthenticationDeleterService!
    var user: UserProtocol!
    
    override func setUp() {
        authenticationDeleterService = AuthenticationDeleterService()
        user = UserMock()
    }
    
    func test_GivenUserIsAuthenticated_WhenDeleteUserAuthenticationIsCalled_ThenShouldReturnUnableToDeleteAccount() {
        
        // When
        authenticationDeleterService.deleteUserAuthentication(user: user, completion: { error in
            
            // Then
            XCTAssertEqual(error, .unableToDeleteAccount)
        })
    }
    
    func test_GivenUserIsAuthenticated_WhenDeleteUserAuthenticationIsCalled_ThenShouldReturnLogInBeforeDeletingTheAccount() {
        
        user = UserErrorRefreshLoginMock()
        
        // When
        authenticationDeleterService.deleteUserAuthentication(user: user, completion: { error in
            
            // Then
            XCTAssertEqual(error, .logInBeforeDeletingTheAccount)
        })
    }
    
    func test_GivenUserIsAuthenticated_WhenDeleteUserAuthenticationIsCalled_ThenShouldNotReturnAnError() {
        
        user = UserSuccessMock()
        
        // When
        authenticationDeleterService.deleteUserAuthentication(user: user, completion: { error in
            
            // Then
            XCTAssertNil(error)
        })
    }
    
}
