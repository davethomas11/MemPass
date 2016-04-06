//
//  MemPassOptionChangesTests.swift
//  MemPass
//
//  Created by David Thomas on 2016-03-19.
//  Copyright © 2016 Dave Anthony Thomas. All rights reserved.
//

import XCTest
@testable import MemPass

class MemPassOptionChangesTests: XCTestCase {
    
    var memPass:MemPass!
    var seed:String = "2289146dc04e35c66958e75792142c2edb9793072002aa160ea08ae664ee95c0"
    
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        memPass = MemPass()
        memPass.reSeed(seed)
        memPass.options.setToDefaults();
        memPass.phrase = "mempass"
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLimit() {
        
        memPass.options.applyLimitBeforeDice = true
        memPass.options.characterLimit = 14
        
        let value = memPass.generate("johny")
        let expected = "#~(^{-> NaRk <-`%$4722-> Kahn <--> French <-9=";
        XCTAssertEqual(expected, value)
    }
    
    func testNoNumbers() {
        
        memPass.options.applyLimitBeforeDice = true
        memPass.options.characterLimit = 14
        memPass.options.hasNumber = false
        
        let value = memPass.generate("johny")
        let expected = "#~(^{-> NaRk <-`%$nnnn-> Kahn <--> French <-n=";
        XCTAssertEqual(expected, value)
    }
    
    func testNoCapitals() {
        
        memPass.options.applyLimitBeforeDice = true
        memPass.options.characterLimit = 14
        memPass.options.hasNumber = false
        memPass.options.hasCapital = false
        
        let value = memPass.generate("johny")
        let expected = "#~(^{-> nark <-`%$nnnn-> kahn <--> french <-n=";
        XCTAssertEqual(expected, value)
    }
    
    func testNoDiceWords() {
        
        memPass.options.characterLimit = 14
        memPass.options.hasNumber = false
        memPass.options.hasCapital = false
        memPass.options.hasDiceWords = false
        
        let value = memPass.generate("johny")
        let expected = "#~(^{`%$nnnnn=";
        XCTAssertEqual(expected, value)
    }
    
    func testNoSpecialChar() {
        
        memPass.options.characterLimit = 14
        memPass.options.hasNumber = false
        memPass.options.hasCapital = false
        memPass.options.hasDiceWords = false
        memPass.options.specialChars = []
        
        let value = memPass.generate("johny")
        let expected = "nnnnfneannnnnd";
        XCTAssertEqual(expected, value)
    }
    
    
}
