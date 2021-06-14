//
//  FirestoreManagerTestCase.swift
//  goveganTests
//
//  Created by Mosma on 11/06/2021.
//

import XCTest
import Firebase

@testable import govegan

class FirestoreManagerTestCase: XCTestCase {
    
    var firestoreManager: FirestoreManager!
    
    override func setUpWithError() throws {
        firestoreManager = FirestoreManager.shared
    }
    
    override func tearDownWithError() throws {
        firestoreManager = nil
        //        clearFirestore()
    }
    
    func test_GivenUserInformationHasBeenRetrieved_WhenAddDocumentWithIsCalled_ThenShouldReturnSuccessCase() {
        
//        let expectation = expectation(description: "Waiting for async operation")
        
        // Given
        firestoreManager.addDocumentWith(userID: "0", username: "", veganStartDate: "01/01/2021 00:00", email: "", completion: { result in
            
//            switch result {
//            case .success(let isASuccess):
//                XCTAssertTrue(isASuccess)
//            default: XCTFail()
//            }
//
//            expectation.fulfill()
        })
        
//        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func test_GivenUserIsPresentInDatabase_WhenGetValueFromDocumentIsCalled_ThenShouldReturnHisVeganStartDate() {
        
        let expectation = expectation(description: "Waiting for async operation")
        
        // When
        firestoreManager.getValueFromDocument(userID: "0", valueToReturn: firestoreManager.veganStartDateKey, completion: { result in
            
            print("Je suis passé dans getValueFromDocument")
            switch result {
            case .success(let result):
                XCTAssertNotNil(result)
                
                // Then
                XCTAssertEqual(result, "01/01/2021 00:00")
                print("Result: \(result)")
            default: XCTFail()
            }
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func test_GivenUserIsPresentButUserIDIsWrong_WhenGetValueFromDocumentIsCalled_ThenShouldReturnAnError() {
        
        let expectation = expectation(description: "Waiting for async operation")
        
        // When
        firestoreManager.getValueFromDocument(userID: "1", valueToReturn: firestoreManager.veganStartDateKey, completion: { result in
            
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .unableToRecoverYourAccount)
            default: XCTFail()
            }
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func test_GivenKeyForDataIsWrong_WhenGetValueFromDocumentIsCalled_ThenShouldReturnAnError() {
        
        let expectation = expectation(description: "Waiting for async operation")
        
        // When
        firestoreManager.getValueFromDocument(userID: "0", valueToReturn: "", completion: { result in
            
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .noData)
            default: XCTFail()
            }
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 3, handler: nil)
    }
}
