//
//  VeganNewsNetworkManager.swift
//  govegan
//
//  Created by Mosma on 31/05/2021.
//

import Foundation

final class VeganNewsNetworkManager {
    
    // Used to be able to perform dependency injection
    init(
        networkManager: NetworkManager = NetworkManager(),
        veganNewsURLProvider: VeganNewsUrlProviderProtocol = VeganNewsURLProvider()
    ) {
        self.networkManager = networkManager
        self.veganNewsURLProvider = veganNewsURLProvider
    }
    
    // MARK: - Internal functions
    
    /// Used to get weather information for a city
    internal func fetchVeganNewsFor(_ language: String, completion: @escaping (Result<VeganNewsResponse, NetworkError>) -> Void) {
        
        //        // Used to handle the case where the text field is empty
        //        guard city.trimmingCharacters(in: .whitespaces) != "" else {
        //            completion(.failure(.emptyTextField))
        //            return
        //        }
        
        guard let url = veganNewsURLProvider.buildNewsAPIURL(with: language) else {
            completion(.failure(.failedToCreateURL))
            return
        }
        
        networkManager.fetch(url: url, completion: completion)
    }
    
    // MARK: - Private properties
    private let networkManager: NetworkManager
    private let veganNewsURLProvider: VeganNewsUrlProviderProtocol
}

