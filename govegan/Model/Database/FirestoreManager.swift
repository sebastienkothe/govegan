//
//  FirestoreManager.swift
//  govegan
//
//  Created by Mosma on 04/06/2021.
//

import Firebase

class FirestoreManager {
    
    // MARK: - Initializer
    init(with firestore: FirestoreProtocol = Firestore.firestore()) {
        self.firestore = firestore
    }
    
    // MARK: - Typealias
    typealias AddDocumentWithCompletionHandler = (Result<Bool, FirestoreManagerError>) -> Void
    typealias GetValueFromDocumentCompletionHandler = (Result<Any?, FirestoreManagerError>) -> Void
    typealias DeleteADocumentCompletionHandler = (FirestoreManagerError?) -> Void
    
    // MARK: - Internal methods
    
    /// Used to add document to the database
    func addDocumentWith(userID: String, userData: [String: Any], completion: @escaping AddDocumentWithCompletionHandler) {
        
        firestore?.collection(.collectionName).document(userID) .setData(userData) { error in
            guard error == nil else {
                return completion(.failure(.unableToCreateAccount))
            }
            
            // Adding the document was successful
            completion(.success(true))
        }
    }
    
    /// Used to fetch document from the database
    func getValueFromDocument(userID: String, valueToReturn: String, completion: @escaping GetValueFromDocumentCompletionHandler) {
        
        firestore?.collection(.collectionName).document(userID) .getDocument { document, error in
            
            guard error == nil else {
                completion(.failure(.unableToRecoverYourAccount))
                return
            }
            
            let data = document?.data()
            
            // Searching the document was successful
            completion(.success(data?[valueToReturn]))
        }
    }
    
    /// Delete a document from the firestore database
    func deleteADocument(userID: String, completion: @escaping DeleteADocumentCompletionHandler) {
        
        firestore?.collection(.collectionName).document(userID) .delete() { error in
            guard error == nil else {
                completion(.unableToRemoveUserFromDatabase)
                return
            }
            
            completion(nil)
        }
    }
    
    /// Used to update an entry in the document like vegan start date
    func updateADocument(userID: String, userData: [String: Any], completion: @escaping ((Result<Void, FirestoreManagerError>) -> Void)) {
        
        firestore?.collection(.collectionName).document(userID).updateData(userData, completion: { error in
            
            guard error == nil else {
                completion(.failure(.unableToUpdateData))
                return
            }
            
            completion(.success(()))
        })
    }
    
    /// Convert a timestamp object to a date
    func convertTimestampObjectToDate(object: Any?) -> Date? {
        guard let valueToReturn = object as? Timestamp else { return nil}
        return valueToReturn.dateValue()
    }
    
    // MARK: - Private properties
    private let firestore: FirestoreProtocol?
}
