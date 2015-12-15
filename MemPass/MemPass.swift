//
//  MemPass.swift
//  MemPass
//
//  Created by David Thomas on 2015-12-10.
//  Copyright © 2015 Dave Anthony Thomas. All rights reserved.
//

import UIKit

class MemPass: NSObject {

    private let CLEAN_INSTALL = "ProkChopMcNelly"
    private let SERVICE = "MemPass"
    private let MEMPASS = "mem@pass.com"
    private let SPECIAL_CHARS = ["!","@","#","$","%","^","`","~","&","*","(",")"]
    
    private var account:String = ""
    private(set) var seed:String = ""
    
    
    override init() {
        super.init()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let isNotFreshInstall = defaults.boolForKey(CLEAN_INSTALL)
        
        if let seed = SSKeychain.passwordForService(SERVICE, account: getAccount()) where isNotFreshInstall {
         
            self.seed = seed
        } else {
            
            reSeed()
        }
        
        defaults.setBool(true, forKey: CLEAN_INSTALL)
        defaults.synchronize()
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
    
    
    func reSeed() -> String {
        
        let now = NSDate().timeIntervalSince1970
        let accesible = UIScreen.mainScreen().accessibilityActivate() ? rand() * 32 : rand()
        let battery = UIDevice.currentDevice().batteryLevel
        let model = UIDevice.currentDevice().localizedModel
        let system = UIDevice.currentDevice().systemName
        let version = UIDevice.currentDevice().systemVersion
        
        let hasher = Sha2()
        if let seed = hasher.sha256("\(now)-\(accesible)-\(battery)-\(model)-\(system)-\(version)[\(account)]") {
            
            self.seed = seed
        } else {
            
            self.seed = NSUUID.init().UUIDString
        }
        
        SSKeychain.setPassword(self.seed, forService: SERVICE, account: account)
        return self.seed
        
    }
    
    func generate(memPass:String) -> String? {
        
        let hasher = Sha2()
        
        if let firstPass = hasher.sha256("\(memPass)-\(String(memPass.characters.reverse()))-|\(seed).)") {
            
            var occurences = [Character:Int]()
            var memPass = firstPass
            
            for character in firstPass.characters {
                
                if occurences[character] == nil {
                    occurences[character] = 1
                } else {
                    occurences[character]!++
                }
     
            }

            var index = 0
            let sorted = occurences.sort({ $0.1 < $1.1 })
            for (character,_) in sorted  {
                
                if index >= SPECIAL_CHARS.count {
                    break
                }
                memPass = memPass.stringByReplacingOccurrencesOfString(String(character), withString: SPECIAL_CHARS[index])
                index++
            }
            
            let alpha = NSCharacterSet.letterCharacterSet()
            var hasUpperCase = false
            for character in memPass.characters {
                let unicode = String(character)
                if let first = unicode.unicodeScalars.first where alpha.longCharacterIsMember(first.value) {
                    
                    memPass = memPass.stringByReplacingOccurrencesOfString(unicode, withString: unicode.uppercaseString, options: NSStringCompareOptions.LiteralSearch, range: memPass.rangeOfString(unicode))
                    hasUpperCase = true
                    break;
                }
            }
            
            if !hasUpperCase {
                memPass += "A"
            }
            
            
            return memPass
        }
        
        
        return nil
    }
    
    
    
}
