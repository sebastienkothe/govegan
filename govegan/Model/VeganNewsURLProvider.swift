//
//  VeganNewsURLProvider.swift
//  govegan
//
//  Created by Mosma on 31/05/2021.
//

import Foundation

class VeganNewsURLProvider: VeganNewsUrlProviderProtocol {
    func buildNewsAPIURL(with language: String) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "newsapi.org"
        urlComponents.path = "/v2/everything"
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: "vegan"),
            URLQueryItem(name: "apiKey", value: "93479e00c5e349ce9cfddc77aa82b6e8"),
            URLQueryItem(name: "language", value: language)
        ]
        return urlComponents.url
    }
}
