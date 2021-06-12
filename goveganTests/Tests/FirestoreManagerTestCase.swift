//
//  FirestoreManagerTestCase.swift
//  goveganTests
//
//  Created by Mosma on 11/06/2021.
//

import XCTest

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
    
    func test_GivenADocumentHasBeenAdded_WhenWeAreTryingToRetrieveSpecificData_ThenReturnsIt() {
        
        // Given
        firestoreManager.addDocumentWith(userID: "0", username: "", veganStartDate: "01/01/2021 00:00", email: "", completion: { result in
            
        })
        
        
        // When
        let expectation = expectation(description: "Waiting for async operation")
        
        firestoreManager.getValueFromDocument(userID: "0", valueToReturn: firestoreManager.veganStartDateKey, completion: { result in
            
            // Then
            switch result {
            case .success(let result):
                XCTAssertNotNil(result)
                XCTAssertEqual(result, "01/01/2021 00:00")
                print("Result: \(result)")
            default: XCTFail()
            }
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}
