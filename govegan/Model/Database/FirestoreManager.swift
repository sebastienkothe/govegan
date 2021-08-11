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
    static let shared = FirestoreManager()
    private init() {}
    
    var firestore: FirestoreProtocol = Firestore.firestore()
    
    var collectionReference: CollectionReferenceProtocol {
        get { return firestore.collection(collectionName) }
        set {}
    }
    
    var documentReference: DocumentReferenceProtocol? {
        get { return collectionReference.document(userID) }
        set {}

    }
    
    typealias AddDocumentWithCompletionHandler = (Result<Bool, FirestoreManagerError>) -> Void
    typealias GetValueFromDocumentCompletionHandler = (Result<Any?, FirestoreManagerError>) -> Void
    typealias DeleteADocumentCompletionHandler = (FirestoreManagerError?) -> Void
    
    // MARK: - Internal functions
    
    /// Used to add document to the database
    func addDocumentWith(userID: String, userData: [String: String], completion: @escaping AddDocumentWithCompletionHandler) {
        self.userID = userID
        referenceForUserData()?.setData(userData) { error in
            guard error == nil else {
                return completion(.failure(.unableToCreateAccount))
            }

            // Adding the document was successful
            completion(.success(true))
        }
    }
    
    /// Used to fetch document from the database
    func getValueFromDocument(userID: String, valueToReturn: String, completion: @escaping GetValueFromDocumentCompletionHandler) {
        self.userID = userID
        referenceForUserData()?.getDocument { document, error in
            
            guard error == nil else {
                completion(.failure(.unableToRecoverYourAccount))
                return
            }
            
            let data = document?.data() as? [String: String]
            
            // Searching the document was successful
            completion(.success(data?[valueToReturn]))
        }
    }
    
    /// Delete a document from the firestore database
    func deleteADocument(userID: String, completion: @escaping DeleteADocumentCompletionHandler) {
        self.userID = userID
        
        referenceForUserData()?.delete() { error in
            guard error == nil else {
                completion(.unableToRemoveUserFromDatabase)
                return
            }
            
            completion(nil)
        }
    }
    
    /// Used to update an entry in the document like vegan start date
    func updateADocument(userID: String, userData: [String: String], completion: @escaping ((Result<Void, FirestoreManagerError>) -> Void)) {
        self.userID = userID
        
        referenceForUserData()?.updateData(userData, completion: { error in
            
            guard error == nil else {
                completion(.failure(.unableToUpdateData))
                return
            }
            
            completion(.success(()))
        })
    }
    
    // MARK: - Private properties
    private let collectionName = "users"
    private var userID = ""
    
    // MARK: - Private functions
    private func referenceForUserData() -> DocumentReferenceProtocol? {
        guard let documentReference = documentReference else { return nil}
        return documentReference
    }
}
