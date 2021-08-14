//
//  AuthenticationServiceTestCase.swift
//  goveganTests
//
//  Created by Mosma on 19/06/2021.
//

import XCTest
import Firebase

@testable import govegan

class AuthenticationServiceTestCase: XCTestCase {
    var authenticationService: AuthenticationService!
    
    override func setUp() {
        authenticationService = AuthenticationService(auth: MockAuth())
    }
    
    func test_GivenUserIsConnected_WhenDisconnectUserFromAppIsCalled_ThenShouldReturnAnError() {
        
        // When
        authenticationService.disconnectUserFromApp { result in
            
            switch result {
            case .failure(let error):
                
                // Then
                XCTAssertEqual(error, .unableToLogOut)
            case .success:
                XCTFail()
            }
        }
    }
    
    func test_GivenUserHasAnAccount_WhenDeleteUserAuthenticationIsCalled_ThenShouldReturnAnError() {
        
        let testMock = AuthenticationDeleterServiceMock()
        
        authenticationService = AuthenticationService(
            authenticationDeleterService: testMock
        )
        
        // When
        authenticationService.deleteUserAuthentication { result in
            
            switch result {
            case .failure(let error):
                
                // Then
                XCTAssertEqual(error, .unableToDeleteAccount)
            case .success:
                XCTFail()
            }
        }
    }
    
    func test_GivenUserHasAnAccount_WhenDeleteUserAuthenticationIsCalledWithMockAuth_ThenShouldReturnAnError() {
        
        let testMock = AuthenticationDeleterServiceMock()
        
        authenticationService = AuthenticationService(
            auth: MockAuth(),
            authenticationDeleterService: testMock
        )
        
        // When
        authenticationService.deleteUserAuthentication { result in
            
            switch result {
            case .failure(let error):
                
                // Then
                XCTAssertEqual(error, .unableToDeleteAccount)
            case .success:
                XCTFail()
            }
        }
    }
    
    
    func test_GivenUserHasAnAccount_WhenDeleteUserAuthenticationIsCalled_ThenShouldNotReturnAnError() {
        
        let testMock = AuthenticationDeleterServiceSuccessMock()
        
        authenticationService = AuthenticationService(
            auth: MockAuthSuccessCases(),
            authenticationDeleterService: testMock
        )
        
        // When
        authenticationService.deleteUserAuthentication { result in
            
            switch result {
            case .failure:
                XCTFail()
            case .success:
                
                // Then
                XCTAssertTrue(true)
            }
        }
    }
    
    func test_GivenUserIsNotConnected_WhenConnectUserWithIsCalled_ThenShouldReturnAnError() {
        
        // When
        authenticationService.connectUserWith("", and: "", completion: { result in
            
            switch result {
            case .failure(let error):
                
                // Then
                XCTAssertEqual(error, .unableToConnectUser)
            case .success:
                XCTFail()
            }
        })
    }
    
    func test_GivenUserIsNotConnected_WhenConnectUserWithIsCalled_ThenShouldNotReturnAnError() {
        
        authenticationService = AuthenticationService(auth: MockAuthSuccessCases())
        
        // When
        authenticationService.connectUserWith("", and: "", completion: { result in
            
            switch result {
            case .failure:
                XCTFail()
            case .success(let result):
                
                // Then
                XCTAssertNotNil(result)
            }
        })
    }
    
    func test_GivenUserHasNoAccount_WhenCreateAccountFromIsCalled_ThenShouldReturnAnError() {
        
        // When
        authenticationService.createAccountFrom("", "", completion: { result in
            
            switch result {
            case .failure(let error):
                
                // Then
                XCTAssertEqual(error, .unableToCreateAccount)
            case .success:
                XCTFail()
            }
        })
    }
    
    func test_GivenUserHasNoAccount_WhenCreateAccountFromIsCalled_ThenShouldNotReturnAnError() {
        
        authenticationService = AuthenticationService(auth: MockAuthSuccessCases())
        
        // When
        authenticationService.createAccountFrom("", "", completion: { result in
            
            switch result {
            case .failure:
                XCTFail()
            case .success(let result):
                
                // Then
                XCTAssertNil(result)
            }
        })
    }
    
    func test_GivenUserEnterACorrectMailAdress_WhenResetPasswordIsCalled_ThenShouldNotReturnAnError() {
        
        authenticationService = AuthenticationService(auth: MockAuthSuccessCases())
        
        // When
        authenticationService.resetPassword(email: "") { result in
            switch result {
            case .failure:
                XCTFail()
            case .success(let result):
                
                // Then
                XCTAssertNotNil(result)
            }
        }
    }
    
    func test_GivenEmailAdressDoesNotExistInTheDB_WhenResetPasswordIsCalled_ThenShouldReturnAnError() {
        
        // When
        authenticationService.resetPassword(email: "") { result in
            switch result {
            case .failure(let error):
                
                // Then
                XCTAssertEqual(error, .unableToResetPassword)
            case .success():
                XCTFail()
            }
        }
    }
}
