//
//  DateHandlerTestCase.swift
//  goveganTests
//
//  Created by Mosma on 14/08/2021.
//

import XCTest
@testable import govegan

class DateHandlerTestCase: XCTestCase {
    
    var dateHandler: DateHandler!
    
    override func setUp() {
        dateHandler = DateHandler(with: LanguageProviderDeviceInEnglishMock())
    }
    
    func test_GivenDateIsInitializedAndDeviceIsInEnglish_WhenConvertDateAsStringIsCalled_ThenShouldReturnAStringWithAComma() {
        
        // Then
        XCTAssertTrue(dateHandler.convertDateAsString(date: Date())!.contains(","))
    }
    
    func test_GivenDateIsInitializedAndDeviceIsInFrench_WhenConvertDateAsStringIsCalled_ThenShouldReturnAStringWithoutComma() {
        
        dateHandler = DateHandler(with: LanguageProviderDeviceInFrenchMock())
        
        // Then
        XCTAssertFalse(dateHandler.convertDateAsString(date: Date())!.contains(","))
    }
}
