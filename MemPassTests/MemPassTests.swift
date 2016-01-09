//
//  MemPassTests.swift
//  MemPass
//
//  Created by David Thomas on 2016-01-02.
//  Copyright © 2016 Dave Anthony Thomas. All rights reserved.
//

import XCTest
@testable import MemPass


class MemPassTests: XCTestCase {
    
    var memPass:MemPass!
    var seed:String = "2289146dc04e35c66958e75792142c2edb9793072002aa160ea08ae664ee95c0"
    
    override func setUp() {
        super.setUp()
        
        memPass = MemPass()
        memPass.reSeed(seed)
        memPass.phrase = "mempass"
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSha256() {
        
        let sha = Sha2()
        let result = sha.sha256("mempass")
        XCTAssertEqual(result, "15c0358bdf1c6c662fa77f7ad8118ed01aa8f2a4b16e7dcb9f5c881f19ee1f4c");
        
    }
    
    func testIntialValue() {
        
        let value = memPass!.getIntialValue("mempass")
        XCTAssertEqual(value, "mempass-ssapmem-|\(seed).)")
    }
    
    func testIntialHash() {
        
        let hash = memPass!.getIntialHash("mempass")
        XCTAssertEqual(hash, "f7cfd42bede24827d8a373d25f4eb3f2c4cd5e7123a7bd96cd0d7d3e8019a9bf")
    }
    
    func testStringSum() {
        
        let sum = memPass!.passwordSum("abcDEFg")
        XCTAssertEqual(sum, 604)
        
    }
    
    func testRemoveNumber() {
        
        let noNum = memPass!.removeNumbersPass("567abc567");
        XCTAssertEqual(noNum, "nnnabcnnn")
    }
    
    func testCapitalLetterPass() {
        XCTAssertEqual(memPass!.capitalLetterPass("abcDEFg"), "ABCDEFg")
    }
    
    func testCapitalLetterPass2() {
        XCTAssertEqual(memPass!.capitalLetterPass("12345"), "12345A")
    }
    
    func testSpecialCharReplace() {
        XCTAssertEqual(memPass!.specialCharPass("mempass-mempass-mempass"), "+=m&}~s{mempass{mempass")
    }
    
    func testDiceWordAt5() {
        XCTAssertEqual(memPass!.dice.wordAt(5), "Aalost")
    }
    
    func testDiceWordCount() {
        
    }
    
    /*func testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measureBlock {
    // Put the code you want to measure the time of here.
    }
    }*/
    
}
