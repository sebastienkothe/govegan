//
//  VeganNewsResponse.swift
//  govegan
//
//  Created by Mosma on 31/05/2021.
//

import Foundation

// MARK: - Welcome
struct VeganNewsResponse: Codable {
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let author: String?
    let title: String
    let url: String
    let urlToImage: String
    let content: String
}
