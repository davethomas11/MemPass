//
//  MemPass.swift
//  MemPass
//
//  Created by David Thomas on 2015-12-10.
//  Copyright © 2015 Dave Anthony Thomas. All rights reserved.
//

import UIKit

class MemPass: NSObject {

    private let OPTIONS_SET = "{OPTSET}"
    private let SERVICE = "MemPass"
    private let MEMPASS = "mem@pass.com"
    
    private var account:String = ""
    private(set) var seed:String = ""
    var options:MemPassOptions = MemPassOptions()
    var dice:MemPassDice = MemPassDice()
    var phrase:String = ""
    
    private static var memPass:MemPass? = nil
    
    override init() {
        super.init()
        
        
        if let seed = SSKeychain.passwordForService(SERVICE, account: getAccount()) {
         
            self.seed = seed
        } else {
            
            reSeed()
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let optionSet = defaults.stringForKey(OPTIONS_SET) {
            options.loadOptions(optionSet)
        }
        
        if !dice.databaseAvailable() {
            options.hasDiceWords = false
            options.saveDefault()
        } else {
            options.hasDiceWords = true
            options.saveDefault()
        }
    }
    
    class func sharedInstance() -> MemPass {        
        
        if let memPass = memPass {
            return memPass
        } else {
            self.memPass = MemPass()
            return self.memPass!
        }
        
    }
    
    private func getAccount() -> String {
        
        if let account = SSKeychain.passwordForService(SERVICE, account: MEMPASS) {
            
            self.account = account
            return account
        
        } else if let uniqueID = UIDevice.currentDevice().identifierForVendor?.UUIDString {
            
            account = uniqueID
        } else {
            
            account = NSUUID.init().UUIDString
            
        }
        SSKeychain.setPassword(account, forService: SERVICE, account: MEMPASS)
     
        return account
    }
    
    
    func reSeed(newSeed:String?=nil) -> String {
        
        if var seed = newSeed {
            
            if seed.containsString("|") {
                
                seed = parseSeedForOptions(seed)
            }
            
            self.seed = seed
            
        } else {
            
            self.seed = self.newSeed()
        }
        
        SSKeychain.setPassword(self.seed, forService: SERVICE, account: account)
        return self.seed
        
    }
    
    private func parseSeedForOptions(var seed:String) -> String {
        var parts = seed.componentsSeparatedByString("|")
        
        if parts.count > 1 {
            seed = parts[0]
            parts.removeFirst()
            
            var optsString = parts[0]
            if parts.count > 1 {
                optsString = parts.reduce("", combine: { $0 + $1})
            }
            
            options.parseSettingsString(optsString)
        }

        return seed
    }
    
    
    private func newSeed() -> String {
        let now = NSDate().timeIntervalSince1970
        let accesible = UIScreen.mainScreen().accessibilityActivate() ? rand() * 32 : rand()
        let battery = UIDevice.currentDevice().batteryLevel
        let model = UIDevice.currentDevice().localizedModel
        let system = UIDevice.currentDevice().systemName
        let version = UIDevice.currentDevice().systemVersion
        
        let hasher = Sha2()
        if let seed = hasher.sha256("\(now)-\(accesible)-\(battery)-\(model)-\(system)-\(version)[\(account)]") {
            
           return seed
        } else {
            
            return NSUUID.init().UUIDString
        }
    }
    
    
    private func specialCharPass(inS:String) -> String {
        
        var occurences = [Character:Int]()
        var memPass = inS
        
        for character in inS.characters {
            
            if occurences[character] == nil {
                occurences[character] = 1
            } else {
                occurences[character]!++
            }
            
        }
        
        var index = 0
        var sorted = occurences.sort({ $0.1 < $1.1 })
        var specialChars = options.specialChars

        while specialChars.count > 0 && sorted.count > 0 {
            
            let character = sorted[0].0
            let scalars = String(character).unicodeScalars
            let value = Int(scalars[scalars.startIndex].value)
            var specialCharIndex = value % specialChars.count
            
            if specialCharIndex >= specialChars.count || specialCharIndex < 0 {
                specialCharIndex = 0
            }
            
            let specialChar = specialChars[specialCharIndex]
            
            if index % options.capitalLetterMod == 0 {
                
                memPass = memPass.stringByReplacingOccurrencesOfString(String(character), withString: specialChar)
            
            } else if let range = memPass.rangeOfString(String(character)){
                
                 memPass = memPass.stringByReplacingCharactersInRange(range, withString: specialChar)
            }
            
            index++
            
            sorted.removeFirst()
            specialChars.removeAtIndex(specialCharIndex)
        }
        
        return memPass
    }
    
    private func capitalLetterPass(inString:String) -> String {
        
        let target = (passwordSum(inString) % options.capitalLetterMod) + 1
        var found = 0
        
        var memPass = inString
        let alpha = NSCharacterSet.letterCharacterSet()
        var hasUpperCase = false
        for character in memPass.characters {
            let unicode = String(character)
            if let first = unicode.unicodeScalars.first where alpha.longCharacterIsMember(first.value) {
                
                memPass = memPass.stringByReplacingOccurrencesOfString(unicode, withString: unicode.uppercaseString, options: NSStringCompareOptions.LiteralSearch, range: memPass.rangeOfString(unicode))
                hasUpperCase = true
                
                found++
                
                if (target == found) {
                    break;
                }
            }
        }
        
        if !hasUpperCase {
            memPass += "A"
        }
        
        return memPass
    }
    
    private func removeNumbersPass(inString:String) -> String {
        
        return inString.stringByReplacingOccurrencesOfString("[0-9]", withString: "n", options: NSStringCompareOptions.RegularExpressionSearch, range: inString.rangeOfString(inString))
    }
    
    private func diceWordPass(var memPass:String) -> String {
        
        let wordCount = dice.getWordCount()
        let sum = passwordSum(phrase + seed)
        var characterCount = memPass.characters.count - 1
        var offset = 100000
        
        let target = (sum % options.diceMod) + 1

        var parts = [String]()
        
        for _ in 1...target {
            if characterCount <= 0 {
                break;
            }
            
            let position = sum % characterCount
            var wordX = sum * offset % wordCount
        
            if wordX <= 0 || wordX >= wordCount {
                wordX = 1
            }
            
            let range = Range(start: memPass.startIndex, end:memPass.startIndex.advancedBy(position))
            parts.append(memPass.substringToIndex(memPass.startIndex.advancedBy(position)))
            memPass = memPass.stringByReplacingCharactersInRange(range, withString: "")
            
            let diceWord = dice.wordAt(wordX)
            
            if options.specialChars.count > 0 {
                parts.append("-> \(diceWord) <-")
            } else {
                parts.append("\(diceWord)")
            }
            
            characterCount = memPass.characters.count
            
            offset--
        }
        
        return parts.reduce("", combine: { $0 + $1 }) + memPass
    }
    
    func passwordSum(pass:String) -> Int {
        
        var memPassSum = 0
        for character in pass.characters {
            let scalars = String(character).unicodeScalars
            let value = Int(scalars[scalars.startIndex].value)
            
            memPassSum += value
        }
        
        return memPassSum
    }
    
    func generate(memPass:String) -> String? {
        
        let hasher = Sha2()
        phrase = memPass
        
        if let firstPass = hasher.sha256("\(memPass)-\(String(memPass.characters.reverse()))-|\(seed).)") {
            
            var memPass = firstPass
            if options.specialChars.count > 0 {
                
                memPass = specialCharPass(memPass)
            }
            
            if options.hasCapital {
                
                memPass = capitalLetterPass(memPass)
            }
            
            if !options.hasNumber {
                
                memPass = removeNumbersPass(memPass)
            }
            
            if options.characterLimit > 0 {
                
                memPass = memPass.substringToIndex(memPass.startIndex.advancedBy(options.characterLimit))
            }
            
            if options.hasDiceWords {
                
                memPass = diceWordPass(memPass)
            }
            
            return memPass
        }
        
        
        return nil
    }
    
    func memPassSyncKey() -> String {
    
        return seed + "|" + options.settingsString()
    }
    
    
}
