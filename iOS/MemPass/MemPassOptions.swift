//
//  MemPassOptions.swift
//  MemPass
//
//  Created by David Thomas on 2015-12-15.
//  Copyright © 2015 Dave Anthony Thomas. All rights reserved.
//

import UIKit

class MemPassOptions: NSObject {

    var specialCharMod = 7
    var capitalLetterMod = 7
    var diceMod = 4
    var numberReplace = "n";
    var defaultUppercase = "A";
    var diceOffset = 100000;
    var diceLeftBrace = "-> ";
    var diceRightBrace = " <-";
    
    let DEFAULT = "DEFAULT"
    var applyLimitBeforeDice = false
    var hasNumber = true
    var hasCapital = true
    var hasDiceWords = true
    var characterLimit = 0
    var specialChars = ["!","@","#","$","%","^","`","~","&","*","(","=","_","{","+","}"]
    
    func setToDefaults() {
        self.hasNumber = true
        self.hasCapital = true
        self.hasDiceWords = true
        self.characterLimit = 0
        self.applyLimitBeforeDice = false
        self.specialChars = ["!","@","#","$","%","^","`","~","&","*","(","=","_","{","+","}"]
    }
    
    
    func loadOptions(named:String) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let options = defaults.objectForKey("MemPassOptionSet[\(named)]") as? [String:AnyObject] {
            
            if let applyLimitBeforeDice = options["applyLimitBeforeDice"] as? Bool {
                self.applyLimitBeforeDice = applyLimitBeforeDice
            }
            
            if let hasNumber = options["hasNumber"] as? Bool {
                self.hasNumber = hasNumber
            }
            
            if let hasCapital = options["hasCapital"] as? Bool {
                self.hasCapital = hasCapital
            }
            
            if let characterLimit = options["characterLimit"] as? Int {
                self.characterLimit = characterLimit
            }
            
            if let specialChars = options["specialChars"] as? [String] {
                self.specialChars = specialChars
            }
            
            if let hasDiceWords = options["hasDiceWords"] as? Bool {
                self.hasDiceWords = hasDiceWords
            }
            
        }
        
        
    }
    
    func getSpecialCharString() -> String {
        return specialChars.reduce("") {
            $0 + $1
        }
    }
    
    func setSpecialCharString(value: String?) {
        specialChars.removeAll()
        
        if let value = value where !value.isEmpty {
            for character in value.characters {
                specialChars.append(String(character))
            }
        }
    }
    
    func loadDefaults() {
        
        loadOptions(DEFAULT)
    }
    
    func saveOptions(namedAs:String, isDefault:Bool=false) -> Bool {
        
        
        var options = [String:AnyObject]()
        
        options["applyLimitBeforeDice"] = self.applyLimitBeforeDice
        options["hasNumber"] = self.hasNumber
        options["hasCapital"] = self.hasCapital
        options["characterLimit"] = self.characterLimit
        options["specialChars"] = self.specialChars
        options["hasDiceWords"] = self.hasDiceWords
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(options, forKey: isDefault ? namedAs : "MemPassOptionSet[\(namedAs)]")
        
        return defaults.synchronize()
    }
    
    func saveDefault() -> Bool {
        
        return self.saveOptions(DEFAULT, isDefault: true)
    }
    
    func settingsString() -> String {
        
        return
            "\(applyLimitBeforeDice ? 1: 0)." +
            "\(hasNumber ? 1 : 0)." +
            "\(hasCapital ? 1 : 0)." +
            "\(hasDiceWords ? 1 : 0)." +
            "\(characterLimit)." + (specialChars.count == 0 ? "" :
            "\(specialChars.reduce("", combine: { $0 + $1 }))")
        
    }
    
    func parseSettingsString(settingsString:String) {
        
        var parts = settingsString.componentsSeparatedByString(".")
        
        if parts.count >= 5 {
            
            if parts[0] == "0" {
                applyLimitBeforeDice = false
            } else if parts[0] == "1" {
                applyLimitBeforeDice = true
            }
            
            if parts[1] == "0" {
                hasNumber = false
            } else if parts[1] == "1" {
                hasNumber = true
            }
            
            if parts[2] == "0" {
                hasCapital = false
            } else if parts[2] == "1" {
                hasCapital = true
            }
            
            if parts[3] == "0" {
                hasDiceWords = false
            } else if parts[3] == "1" {
                hasDiceWords = true
            }
            
            if let limit = Int(parts[4]) {
                self.characterLimit = limit
            }
            
            let specialCharsString = settingsString.stringByReplacingOccurrencesOfString("^([0-9]+.){5}", withString: "", options: NSStringCompareOptions.RegularExpressionSearch)
            
            specialChars.removeAll()
            if (!specialCharsString.isEmpty) {
                
                self.setSpecialCharString(specialCharsString)
            }
            
            saveDefault()
            
        }
        
        
        
        
    }
    
}
