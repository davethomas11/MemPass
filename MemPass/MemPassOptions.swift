//
//  MemPassOptions.swift
//  MemPass
//
//  Created by David Thomas on 2015-12-15.
//  Copyright © 2015 Dave Anthony Thomas. All rights reserved.
//

import UIKit

class MemPassOptions: NSObject {

    var specialCharMod = 3
    var capitalLetterMod = 7
    
    let DEFAULT = "DEFAULT"
    var hasNumber = true
    var hasCapital = true
    var characterLimit = 0
    var specialChars = ["!","@","#","$","%","^","`","~","&","*","(","=","_","{","+","}"]
    
    
    func loadOptions(named:String) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let options = defaults.objectForKey("MemPassOptionSet[\(named)]") as? [String:AnyObject] {
            
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
            
            
        }
   
        
    }
    
    func loadDefaults() {
        
        loadOptions(DEFAULT)        
    }
    
    func saveOptions(namedAs:String, isDefault:Bool=false) -> Bool {
        
        
        var options = [String:AnyObject]()
        
        options["hasNumber"] = self.hasNumber
        options["hasCapital"] = self.hasCapital
        options["characterLimit"] = self.characterLimit
        options["specialChars"] = self.specialChars
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(options, forKey: isDefault ? namedAs : "MemPassOptionSet[\(namedAs)]")
        
        return defaults.synchronize()
    }
    
    func saveDefault() -> Bool {
        
        return self.saveOptions(DEFAULT, isDefault: true)
    }
    
    func settingsString() -> String {
        
        return
            "\(hasNumber ? 1 : 0)." +
            "\(hasCapital ? 1 : 0)." +
                "\(characterLimit)." + (specialChars.count == 0 ? "" :
            "\(specialChars.reduce("", combine: { $0 + $1 }))")
        
    }
    
    func parseSettingsString(settingsString:String) {
        
        var parts = settingsString.componentsSeparatedByString(".")
        
        if parts.count >= 4 {
            
            if parts[0] == "0" {
                hasNumber = true
            } else if parts[0] == "1" {
                hasNumber = false
            }
            
            if parts[1] == "0" {
                hasCapital = true
            } else if parts[1] == "1" {
                hasCapital = false
            }
            
            if let limit = Int(parts[2]) {
                self.characterLimit = limit
            }
        
            parts.removeFirst()
            parts.removeFirst()
            parts.removeFirst()
            
            specialChars.removeAll()
            
            var specialCharsString = parts[0]
            if parts.count > 1 {
                specialCharsString = parts.reduce("", combine: { $0 + $1 })
            }
            
            if (!specialCharsString.isEmpty) {
                
                
                for character in specialCharsString.characters {
                    specialChars.append(String(character))
                }
            }
            
        }
        
        
        
        
    }
    
}
