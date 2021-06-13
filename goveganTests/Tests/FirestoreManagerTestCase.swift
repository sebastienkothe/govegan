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
        
        let user = Auth.auth().currentUser?.email
        
        print("Mail: \(user ?? "")")
        
        let expectation = expectation(description: "Waiting for async operation")
        
        // Given
        firestoreManager.addDocumentWith(userID: "0", username: "", veganStartDate: "01/01/2021 00:00", email: "", completion: { result in
            
            print("Je suis passé dans addDocument")
            switch result {
            case .success(let isASuccess):
                XCTAssertTrue(isASuccess)
            default: XCTFail()
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 3, handler: nil)
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
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}
