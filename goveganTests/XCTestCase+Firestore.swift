//
//  XCTestCase+Firestore.swift
//  goveganTests
//
//  Created by Mosma on 11/06/2021.
//

import XCTest
import Firebase

extension XCTestCase {
    
    /// Calls the delete operation on the entire database and waits for the operation to be finished using semaphores
    func clearFirestore() {
        let semaphore = DispatchSemaphore(value: 0)
        let projectId = FirebaseApp.app()!.options.projectID!
        let url = URL(string: "http://localhost:8020/emulator/v1/projects/\(projectId)/databases/(default)/documents")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        let task = URLSession.shared.dataTask(with: request) { _,_,_ in
            print("Firestore cleared")
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
}
