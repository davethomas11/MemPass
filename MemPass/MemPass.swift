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
    
    func capitalLetterPass(inString:String) -> String {
        
        var memPassSum = 0
        for character in inString.characters {
            let scalars = String(character).unicodeScalars
            let value = Int(scalars[scalars.startIndex].value)
            
            memPassSum += value
        }
        
        let target = memPassSum % options.capitalLetterMod
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
        
        return inString.stringByReplacingOccurrencesOfString(inString, withString: "[0-9]", options: NSStringCompareOptions.RegularExpressionSearch, range: inString.rangeOfString(inString))
    }
    
    func generate(memPass:String) -> String? {
        
        let hasher = Sha2()
        
        
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
            
            return memPass
        }
        
        
        return nil
    }
    
    func memPassSyncKey() -> String {
    
        return seed + "|" + options.settingsString()
    }
    
    
}
