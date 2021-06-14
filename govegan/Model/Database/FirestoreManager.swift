//
//  FirestoreManager.swift
//  govegan
//
//  Created by Mosma on 04/06/2021.
//

import Foundation
import Firebase

class FirestoreManager {
    
    // MARK: - Internal properties
    
    // root = Firestore.firestore().collection(environment)
    let collectionName = "users"
    let usernameKey = "username"
    let veganStartDateKey = "veganStartDate"
    let emailKey = "email"
    
    static let shared = FirestoreManager()
    private init() {}
    
    typealias AddDocumentWithCompletionHandler = (Result<Bool, FirestoreManagerError>) -> Void
    typealias GetValueFromDocumentCompletionHandler = (Result<String, FirestoreManagerError>) -> Void
    
    // MARK: - Internal functions
    
    /// Used to add document to the database
    func addDocumentWith(userID: String, username: String, veganStartDate: String, email: String, completion: @escaping AddDocumentWithCompletionHandler) {
        
        referenceForUserData(userID: userID).setData([usernameKey: username, veganStartDateKey: veganStartDate, emailKey: email]) { error in
            
            guard error == nil else {
                return completion(.failure(.unableToCreateAccount))
            }
            
            // Adding the document was successful
            completion(.success(true))
        }
    }
    
    
    /// Used to fetch document from the database
    func getValueFromDocument(userID: String, valueToReturn: String, completion: @escaping GetValueFromDocumentCompletionHandler)   {
        referenceForUserData(userID: userID).getDocument { document, error in
            guard let document = document, document.exists else {
                completion(.failure(.unableToRecoverYourAccount))
                return
            }
            
            guard let data = document.data() as? [String: String], let valueToReturn = data[valueToReturn] else {
                completion(.failure(.noData))
                return
            }
            
            // Searching the document was successful
            completion(.success(valueToReturn))
        }
    }
    
    // MARK: - Private functions
    private func referenceForUserData(userID: String) -> DocumentReference {
        return Firestore.firestore().collection(collectionName)
            .document(userID)
    }
}
