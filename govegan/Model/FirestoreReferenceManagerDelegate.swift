//
//  FirestoreReferenceManagerDelegate.swift
//  govegan
//
//  Created by Mosma on 04/06/2021.
//

import Foundation

protocol FirestoreManagerDelegate: AnyObject {
    func operationFirestoreCompletedWith(error: Error?)
}
