//
//  LanguageProvider+Mock.swift
//  govegan
//
//  Created by Mosma on 14/08/2021.
//

import Foundation

// MARK: - LanguageProviderProtocol
protocol LanguageProviderProtocol {
    var getDeviceLanguage: String? { get }
}

class LanguageProviderDeviceInFrenchMock: LanguageProviderProtocol {
    var getDeviceLanguage: String? { return "fr"}
}

class LanguageProviderDeviceInEnglishMock: LanguageProviderProtocol {
    var getDeviceLanguage: String? { return "en"}
}

extension LanguageProvider: LanguageProviderProtocol {}
