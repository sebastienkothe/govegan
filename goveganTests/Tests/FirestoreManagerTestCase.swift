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
        firestoreManager = FirestoreManager(with: FirestoreMock())
    }
    
    func test_GivenWeNeedToAddADocumentInDatabase_WhenAddDocumentWithIsCalled_ThenShouldReturnAnError() {
        
        // Given
        let data: [String: Any] = [:]
        
        // When
        firestoreManager.addDocumentWith(userID: "", userData: data, completion: { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                
                // Then
                XCTAssertEqual(error, .unableToCreateAccount)
            }
        })
    }
    
    func test_GivenWeNeedToAddADocumentInDatabase_WhenAddDocumentWithIsCalled_ThenShouldNotReturnAnError() {
        
        firestoreManager = FirestoreManager(with: FirestoreSuccessMock())
        
        // Given
        let data: [String: Any] = [:]
        
        // When
        firestoreManager.addDocumentWith(userID: "", userData: data, completion: { result in
            switch result {
            case .success(let success):
                
                // Then
                XCTAssertTrue(success)
            case .failure:
                XCTFail()
            }
        })
    }
    
    func test_GivenUserIsPresentInDatabase_WhenGetValueFromDocumentIsCalled_ThenShouldNotReturnAnError() {
        
        firestoreManager = FirestoreManager(with: FirestoreSuccessMock())
        
        // When
        firestoreManager.getValueFromDocument(userID: "", valueToReturn: "", completion: { result in
            
            switch result {
            case .failure:
                XCTFail()
            case .success(_):
                
                // Then
                print("Test passed")
                break
            }
        })
    }
    
    func test_GivenUserIsPresentButUserIDIsWrong_WhenGetValueFromDocumentIsCalled_ThenShouldReturnAnError() {
        
        // When
        firestoreManager.getValueFromDocument(userID: "", valueToReturn: "", completion: { result in
            
            switch result {
            case .failure(let error):
                
                // Then
                XCTAssertEqual(error, .unableToRecoverYourAccount)
            default: XCTFail()
            }
        })
    }
    
    func test_GivenUserHasAnAccountInTheDatabase_WhenDeleteADocumentIsCalled_ThenShouldReturnAnError() {
        
        // When
        firestoreManager.deleteADocument(userID: "", completion: { error in
            
            if let error = error {
                
                // Then
                XCTAssertEqual(error, .unableToRemoveUserFromDatabase)
            } else {
                XCTFail()
            }
        })
    }
    
    func test_GivenUserHasAnAccountInTheDatabase_WhenDeleteADocumentIsCalled_ThenShouldNotReturnAnError() {
        
        firestoreManager = FirestoreManager(with: FirestoreSuccessMock())
        
        // When
        firestoreManager.deleteADocument(userID: "", completion: { error in
            
            // Then
            XCTAssertNil(error)
        })
    }
    
    func test_GivenUserWantsToUpdateHisVeganStartDate_WhenUpdateADocumentIsCalled_ThenShouldNotReturnAnError() {
        
        firestoreManager = FirestoreManager(with: FirestoreSuccessMock())
        
        // Given
        let data: [String: Any] = [:]
        
        // When
        firestoreManager.updateADocument(userID: "", userData: data, completion: { result in
            switch result {
            case .success(let success):
                
                // Then
                XCTAssertNotNil(success)
            case .failure:
                XCTFail()
            }
        })
    }
    
    func test_GivenUserWantsToUpdateHisVeganStartDate_WhenUpdateADocumentIsCalled_ThenShouldReturnAnError() {
        
        // Given
        let data: [String: String] = [:]
        
        // When
        firestoreManager.updateADocument(userID: "", userData: data, completion: { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                
                // Then
                XCTAssertEqual(error, .unableToUpdateData)
            }
        })
    }
    
    func test_GivenArrayContainsHeterogeneousValues_WhenConvertTimestampObjectToDateIsCalled_ThenShouldReturnADate() {
        
        // Given
        let array = ["Salut", Timestamp()] as [Any]
        
        // When
        let date = firestoreManager.convertTimestampObjectToDate(object: array[1])
        
        // Then
        XCTAssertNotNil(date!)
    }
    
    func test_GivenArrayContainsHeterogeneousValuesWithoutTimestampObject_WhenConvertTimestampObjectToDateIsCalled_ThenShouldReturnNil() {
        
        // Given
        let array = ["Salut"] as [Any]
        
        // When
        let date = firestoreManager.convertTimestampObjectToDate(object: array[0])
        
        // Then
        XCTAssertNil(date)
    }
}
