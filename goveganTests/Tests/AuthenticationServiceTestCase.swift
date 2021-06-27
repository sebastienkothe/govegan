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
    var user: UserProtocol!
    
    override func setUp() {
        authenticationService = AuthenticationService(auth: MockAuth())
    }
    
    func test_GivenUserIsConnected_WhenDisconnectUserFromAppIsCalled_ThenShouldReturnAnError() {
        
        let expectation = XCTestExpectation()
        
        authenticationService.disconnectUserFromApp { result in
            
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .unableToLogOut)
            case .success:
                XCTFail()
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_GivenUserHasAnAccount_WhenDeleteUserAuthenticationIsCalled_ThenShouldReturnAnError() {
        
        let expectation = XCTestExpectation()
        let testMock = AuthenticationDeleterServiceMock()
        
        authenticationService = AuthenticationService(
            authenticationDeleterService: testMock
        )
        
        authenticationService.deleteUserAuthentication { result in
            
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .unableToDeleteAccount)
            case .success:
                XCTFail()
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_GivenUserHasAnAccount_WhenDeleteUserAuthenticationIsCalledWithMockAuth_ThenShouldReturnAnError() {
        
        let expectation = XCTestExpectation()
        let testMock = AuthenticationDeleterServiceMock()
        
        
        authenticationService = AuthenticationService(
            auth: MockAuth(),
            authenticationDeleterService: testMock
        )
        
        authenticationService.deleteUserAuthentication { result in
            
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .unableToDeleteAccount)
            case .success:
                XCTFail()
            }
            
            expectation.fulfill()
        }
        
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    
    func test_GivenUserHasAnAccount_WhenDeleteUserAuthenticationIsCalled_ThenShouldNotReturnAnError() {
        
        let expectation = XCTestExpectation()
        let testMock = AuthenticationDeleterServiceSuccessMock()
        
        authenticationService = AuthenticationService(
            auth: MockAuthSuccessCases(),
            authenticationDeleterService: testMock
        )
        
        authenticationService.deleteUserAuthentication { result in
            
            switch result {
            case .failure:
                XCTFail()
            case .success:
                XCTAssertTrue(true)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_GivenUserIsNotConnected_WhenConnectUserWithIsCalled_ThenShouldReturnAnError() {
        
        let expectation = XCTestExpectation()
        
        authenticationService.connectUserWith("sebastien.kothe@icloud.com", and: "Mosma2973@", completion: { result in
            
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .unableToConnectUser)
            case .success:
                XCTFail()
            }
            
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_GivenUserIsNotConnected_WhenConnectUserWithIsCalled_ThenShouldNotReturnAnError() {
        
        let expectation = XCTestExpectation()
        authenticationService = AuthenticationService(auth: MockAuthSuccessCases())
        authenticationService.connectUserWith("sebastien.kothe@icloud.com", and: "Mosma2973@", completion: { result in
            
            switch result {
            case .failure:
                XCTFail()
            case .success(let result):
                XCTAssertNotNil(result)
            }
            
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_GivenUserHasNoAccount_WhenCreateAccountFromIsCalled_ThenShouldReturnAnError() {
        
        let expectation = XCTestExpectation()
        
        authenticationService.createAccountFrom("sebastien.kothe@icloud.com", "Mosma2973@", completion: { result in
            
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .unableToCreateAccount)
            case .success:
                XCTFail()
            }
            
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_GivenUserHasNoAccount_WhenCreateAccountFromIsCalled_ThenShouldNotReturnAnError() {
        
        let expectation = XCTestExpectation()
        authenticationService = AuthenticationService(auth: MockAuthSuccessCases())
        authenticationService.createAccountFrom("sebastien.kothe@icloud.com", "Mosma2973@", completion: { result in
            
            switch result {
            case .failure:
                XCTFail()
            case .success(let result):
                XCTAssertNil(result)
            }
            
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 0.1)
    }
}
