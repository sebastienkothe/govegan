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
    let passwordKey = "password"
    
    var userID = ""
    
    var firestore: FirestoreProtocol = Firestore.firestore()
    var authenticationService = AuthenticationService()
    var collectionReference: CollectionReferenceProtocol {
        get { return firestore.collection(collectionName) }
        set {}
    }
    var documentReference: DocumentReferenceProtocol? {
        get { return collectionReference.document(userID) }
        set {}
    }
    
    static let shared = FirestoreManager()
    
    private init() {}
    
    typealias AddDocumentWithCompletionHandler = (Result<Bool, FirestoreManagerError>) -> Void
    typealias GetValueFromDocumentCompletionHandler = (Result<String, FirestoreManagerError>) -> Void
    typealias DeleteADocumentCompletionHandler = (FirestoreManagerError?) -> Void
    
    // MARK: - Internal functions
    
    /// Used to add document to the database
    func addDocumentWith(userID: String, username: String, veganStartDate: String, email: String, password: String, completion: @escaping AddDocumentWithCompletionHandler) {
        self.userID = userID
        Firestore.firestore().collection(collectionName).document(userID).setData([usernameKey: username, veganStartDateKey: veganStartDate, emailKey: email, passwordKey: password]) { error in

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
    
    // MARK: - Private functions
    private func referenceForUserData() -> DocumentReferenceProtocol? {
        guard let documentReference = documentReference else { return nil}
        return documentReference
    }
}

// MARK: - DocumentSnapshotProtocol
protocol DocumentSnapshotProtocol {
    
}

class DocumentSnapshotMock: DocumentSnapshotProtocol {}

extension DocumentSnapshot: DocumentSnapshotProtocol {}

// MARK: - FirestoreProtocol
protocol FirestoreProtocol {
    func collection(_ collectionPath: String) -> CollectionReferenceProtocol
}

class FirestoreMock: FirestoreProtocol {
    
    let collectionName = "users"
    
    func collection(_ collectionPath: String) -> CollectionReferenceProtocol {
        return CollectionReferenceMock()
    }
}

class FirestoreSuccessMock: FirestoreProtocol {
    let collectionName = "users"
    
    func collection(_ collectionPath: String) -> CollectionReferenceProtocol {
        return CollectionReferenceSuccessMock()
    }
}

extension Firestore: FirestoreProtocol {
    func collection(_ collectionPath: String) -> CollectionReferenceProtocol {
        return (collection(collectionPath) as CollectionReference) as CollectionReferenceProtocol
    }
}

// MARK: - CollectionReferenceProtocol
protocol CollectionReferenceProtocol {
    func document(_ documentPath: String) -> DocumentReferenceProtocol
}

class CollectionReferenceMock: CollectionReferenceProtocol {
    func document(_ documentPath: String) -> DocumentReferenceProtocol {
        return DocumentReferenceMock()
    }
}

class CollectionReferenceSuccessMock: CollectionReferenceProtocol {
    func document(_ documentPath: String) -> DocumentReferenceProtocol {
        return DocumentReferenceSuccessMock()
    }
}

extension CollectionReference: CollectionReferenceProtocol {
    func document(_ documentPath: String) -> DocumentReferenceProtocol {
        return (document(documentPath) as DocumentReference) as DocumentReferenceProtocol
    }
}

// MARK: - CollectionReferenceProtocol

typealias DocumentDeleteCompletion = (_ error: Error?) -> Void
typealias GetDocumentCompletion = (DocumentSnapshot?, Error?) -> Void

protocol DocumentReferenceProtocol {
    func delete(completion: DocumentDeleteCompletion?)
    func getDocument(completion: @escaping GetDocumentCompletion)
    
//    func setData()
//    func getDocument()
}

class DocumentReferenceMock : DocumentReferenceProtocol {
    func getDocument(completion: @escaping GetDocumentCompletion) {
        completion(nil, MockError.error)
    }
    
    func delete(completion: DocumentDeleteCompletion?) {
        completion!(MockError.error)
    }
}

class DocumentReferenceSuccessMock: DocumentReferenceProtocol {
    func getDocument(completion: @escaping GetDocumentCompletion) {
        completion(nil, nil)
    }
    
    func delete(completion: DocumentDeleteCompletion?) {
        completion!(nil)
    }
}

extension DocumentReference: DocumentReferenceProtocol {}
