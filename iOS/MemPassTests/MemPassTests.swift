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
        memPass.options.setToDefaults();
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
    
    func testMemPass() {
        
        let value = memPass.generate("mempass")
        let expected = "=&#F!+}^~dE2+_2&d8{(&3d2@f+eb3f2c+cd5e&*23-> less <-a&bd%`cd$d&d3e8019a9bf";
        XCTAssertEqual(expected, value)
    }
    
    func testMemPass2() {
        
        let value = memPass.generate("johny")
        let expected = "#~(^{`%$47229=+_&D*+4466d-> Nark <-}5735!e+2+@b55d58bd3a56&3a@+7+f-> Kahn <-e9384&-> French <-&5";
        XCTAssertEqual(expected, value)
    }
    
    func testMemPass3() {
        
        let value = memPass.generate("cat 5% arb")
        let expected = "+*72$%=_A{^@08(2}70&7~}3636&&6`}B9Ab!}bfd&&%&3e&eadb7f}d336-> flavin <-af2-> Cowper <-af";
        XCTAssertEqual(expected, value)
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
        XCTAssertEqual(memPass!.capitalLetterPass("abcDEFg"), "AbCdEFg")
    }
    
    func testCapitalLetterPass2() {
        XCTAssertEqual(memPass!.capitalLetterPass("12345"), "12345An")
    }
    
    func testSpecialCharReplace() {
        XCTAssertEqual(memPass!.specialCharPass("mempass-mempass-mempass"), "@$m(~&s{mempass{mempass")
    }
    
    func testSpecialCharReplace2() {
        XCTAssertEqual(memPass!.specialCharPass("mempassroadrabbit-mempass"), "#@m^+!s$&a(ra}b~={mem^ass")
    }
    
    func testSpecialCharReplace3() {
        XCTAssertEqual(memPass!.specialCharPass("mempassrig^&8s-mempass"), "%_m#+$s&(=^`@s!memp+ss")
    }
    
    func testDiceWordAt5() {
        XCTAssertEqual(memPass!.dice.wordAt(5), "Aalost")
    }
    
    func testDiceWordAt40005() {
        XCTAssertEqual(memPass!.dice.wordAt(40005), "woodsy")
    }
    
    func testDiceWordCount() {
        XCTAssertEqual(40638, memPass!.dice.getWordCount())
    }
    
    func testOptions() {
        
        let test_options_string = "0.1.0.1.0.~`!@|.$%()0";
        let options = MemPassOptions()
        options.parseSettingsString(test_options_string);
        
        XCTAssertEqual(options.settingsString(), test_options_string);
    
    }
    
}
