//
//  FirestoreManager.swift
//  govegan
//
//  Created by Mosma on 04/06/2021.
//

import Foundation
import Firebase

class FirestoreManager {
    weak var delegate: FirestoreManagerDelegate?
    
    let collectionName = "users"
    
    // root = Firestore.firestore().collection(environment)
    let usernameKey = "username"
    let veganStartDateKey = "veganStartDate"
    let emailKey = "email"
    
    func referenceForUserData(userID: String) -> DocumentReference {
        return Firestore.firestore().collection(collectionName)
            .document(userID)
    }
    
    func addDocumentWith(userID: String, username: String, veganStartDate: String, email: String) {
        referenceForUserData(userID: userID).setData([
            usernameKey: username,
            veganStartDateKey: veganStartDate,
            emailKey: email
        ]) { [weak self] (error) in
            self?.delegate?.operationFirestoreCompletedWith(error: error)
        }
    }
    
    func getValueFromDocument(userID: String, valueToReturn: String, completion: @escaping ((String?) -> ()))   {
        let docRef = referenceForUserData(userID: userID)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let data = document.data() as? [String: String] else { return }
                let valueToReturn = data[valueToReturn]
                completion(valueToReturn)
            } else {
                print("Document does not exist")
                completion(nil)
            }
        }
    }
    
    func checkIfDocumentExistsFrom(userID: String) -> Bool {
        let docRef = Firestore.firestore().collection(collectionName).document(userID)
        var documentIsAvailable: Bool = false
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists { documentIsAvailable = true}
        }
        return documentIsAvailable
    }
}
