//
//  VeganNewsUrlProviderProtocol.swift
//  govegan
//
//  Created by Mosma on 31/05/2021.
//

import Foundation

protocol VeganNewsUrlProviderProtocol {
    func buildNewsAPIURL(with city: String) -> URL?
}
