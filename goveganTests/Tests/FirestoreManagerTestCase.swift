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
    
    override func setUp() {
        firestoreManager = FirestoreManager.shared
        firestoreManager.firestore = FirestoreMock()
        firestoreManager.collectionReference = CollectionReferenceMock()
        firestoreManager.documentReference = DocumentReferenceMock()
    }
    
    func test_GivenWeNeedToAddADocumentInDatabase_WhenAddDocumentWithIsCalled_ThenShouldReturnAnError() {
        
        // Given
        firestoreManager.addDocumentWith(userID: "", username: "", veganStartDate: "", email: "", password: "", completion: { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .unableToCreateAccount)
            }
        })
    }
    
    func test_GivenWeNeedToAddADocumentInDatabase_WhenAddDocumentWithIsCalled_ThenShouldNotReturnAnError() {
        
        firestoreManager.firestore = FirestoreSuccessMock()
        firestoreManager.collectionReference = CollectionReferenceSuccessMock()
        firestoreManager.documentReference = DocumentReferenceSuccessMock()
        
        // Given
        firestoreManager.addDocumentWith(userID: "0938420284702", username: "Sébastien", veganStartDate: "20/01/1988 00:00", email: "sebastien.kothe@icloud.com", password: "Mododueznd2@", completion: { result in
            switch result {
            case .success(let success):
                XCTAssertTrue(success)
            case .failure:
                XCTFail()
            }
        })
    }
    
    func test_GivenUserIsPresentInDatabase_WhenGetValueFromDocumentIsCalled_ThenShouldReturnHisVeganStartDate() {
        
        let expectation = expectation(description: "Waiting for async operation")
        
        // When
        firestoreManager.getValueFromDocument(userID: "0", valueToReturn: firestoreManager.veganStartDateKey, completion: { result in
            
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
        
        waitForExpectations(timeout: 0.1, handler: nil)
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
        
        waitForExpectations(timeout: 0.1, handler: nil)
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
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func test_GivenUserHasAnAccountInTheDatabase_WhenDeleteADocumentIsCalled_ThenShouldReturnAnError() {
        let expectation = expectation(description: "Waiting for async operation")
        
        // When
        firestoreManager.deleteADocument(userID: "0", completion: { error in
            
            if let error = error {
                XCTAssertEqual(error, .unableToRemoveUserFromDatabase)
            } else {
                XCTFail()
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func test_GivenUserHasAnAccountInTheDatabase_WhenDeleteADocumentIsCalled_ThenShouldNotReturnAnError() {
        
        firestoreManager.firestore = FirestoreSuccessMock()
        firestoreManager.collectionReference = CollectionReferenceSuccessMock()
        firestoreManager.documentReference = DocumentReferenceSuccessMock()
        
        let expectation = expectation(description: "Waiting for async operation")
        
        // When
        firestoreManager.deleteADocument(userID: "0", completion: { error in
            
            XCTAssertNil(error)
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
