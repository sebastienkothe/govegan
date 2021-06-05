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
    
    let environment = "users"
    
    // root = Firestore.firestore().collection(environment)
    let usernameKey = "username"
    let veganStartDateKey = "veganStartDate"
    
    func referenceForUserData(uid: String) -> DocumentReference {
        return Firestore.firestore().collection(environment)
            .document(uid)
    }
    
    func addDocumentFrom(uid: String, username: String, veganStartDate: String) {
        Firestore.firestore().collection(environment).document(uid).setData([
            usernameKey: username,
            veganStartDateKey: veganStartDate
        ]) { [weak self] (error) in
            self?.delegate?.operationFirestoreCompletedWith(error: error)
        }
    }
}
