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
        
        let data: [String: String] = [.usernameKey : "", .veganStartDateKey: "", .emailKey: ""]
        
        // Given
        firestoreManager.addDocumentWith(userID: "", userData: data, completion: { result in
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
        
        let data: [String: String] = [.usernameKey : "Sébastien", .veganStartDateKey: "20/01/1988 00:00", .emailKey: "sebastien.kothe@icloud.com"]
        
        // Given
        firestoreManager.addDocumentWith(userID: "0938420284702", userData: data, completion: { result in
            switch result {
            case .success(let success):
                XCTAssertTrue(success)
            case .failure:
                XCTFail()
            }
        })
    }
    
    func test_GivenUserIsPresentInDatabase_WhenGetValueFromDocumentIsCalled_ThenShouldNotReturnAnError() {
        
        firestoreManager.firestore = FirestoreSuccessMock()
        firestoreManager.collectionReference = CollectionReferenceSuccessMock()
        firestoreManager.documentReference = DocumentReferenceSuccessMock()
        
        let expectation = expectation(description: "Waiting for async operation")
        
        // When
        firestoreManager.getValueFromDocument(userID: "0", valueToReturn: .veganStartDateKey, completion: { result in
            
            switch result {
            case .failure(let error):
                XCTAssertNil(error)
            case .success(_):
                break
            }
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func test_GivenUserIsPresentButUserIDIsWrong_WhenGetValueFromDocumentIsCalled_ThenShouldReturnAnError() {
        
        let expectation = expectation(description: "Waiting for async operation")
        
        // When
        firestoreManager.getValueFromDocument(userID: "1", valueToReturn: .veganStartDateKey, completion: { result in
            
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .unableToRecoverYourAccount)
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
    
    func test_GivenUserWantsToUpdateHisVeganStartDate_WhenUpdateADocumentIsCalled_ThenShouldNotReturnAnError() {
        
        firestoreManager.firestore = FirestoreSuccessMock()
        firestoreManager.collectionReference = CollectionReferenceSuccessMock()
        firestoreManager.documentReference = DocumentReferenceSuccessMock()
        
        let expectation = expectation(description: "Waiting for async operation")
        
        let data: [String: String] = [.veganStartDateKey: "22/07/2021 03:05"]
        // When
        firestoreManager.updateADocument(userID: "0", userData: data, completion: { result in
            switch result {
            case .success(let success):
                XCTAssertNotNil(success)
            case .failure:
                XCTFail()
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func test_GivenUserWantsToUpdateHisVeganStartDate_WhenUpdateADocumentIsCalled_ThenShouldReturnAnError() {
        
        let expectation = expectation(description: "Waiting for async operation")
        
        let data: [String: String] = [.veganStartDateKey: "22/07/2021 03:05"]
        
        // When
        firestoreManager.updateADocument(userID: "0", userData: data, completion: { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .unableToUpdateData)
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
