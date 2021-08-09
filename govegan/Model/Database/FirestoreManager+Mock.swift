//
//  FirestoreManager+Mock.swift
//  govegan
//
//  Created by Mosma on 09/08/2021.
//

import Foundation
import Firebase

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

// MARK: - DocumentReferenceProtocol
typealias DocumentDeleteCompletion = (_ error: Error?) -> Void
typealias GetDocumentCompletion = (DocumentSnapshot?, Error?) -> Void

protocol DocumentReferenceProtocol {
    func delete(completion: DocumentDeleteCompletion?)
    func getDocument(completion: @escaping GetDocumentCompletion)
    func setData(_ documentData: [String : Any], completion: ((Error?) -> Void)?)
}

class DocumentReferenceMock : DocumentReferenceProtocol {
    func setData(_ documentData: [String : Any], completion: ((Error?) -> Void)?) {
        completion!(MockError.error)
    }
    
    func getDocument(completion: @escaping GetDocumentCompletion) {
        completion(nil, MockError.error)
    }
    
    func delete(completion: DocumentDeleteCompletion?) {
        completion!(MockError.error)
    }
}

class DocumentReferenceSuccessMock: DocumentReferenceProtocol {
    func setData(_ documentData: [String : Any], completion: ((Error?) -> Void)?) {
        completion!(nil)
    }
    
    func getDocument(completion: @escaping GetDocumentCompletion) {
        completion(nil, nil)
    }
    
    func delete(completion: DocumentDeleteCompletion?) {
        completion!(nil)
    }
}

extension DocumentReference: DocumentReferenceProtocol {}

