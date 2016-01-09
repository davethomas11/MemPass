//
//  MemPassDice.swift
//  MemPass
//
//  Created by David Thomas on 2015-12-20.
//  Copyright © 2015 Dave Anthony Thomas. All rights reserved.
//

import UIKit
import CoreData

class MemPassDice {

    lazy var managedObjectModel:NSManagedObjectModel? = {
        
        guard let url = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd") else {
            
            print("An error occured getting managed object model file")
            return nil
        }
        
        let model = NSManagedObjectModel(contentsOfURL: url)
        
        return model
        
    }()
    
    lazy var documentsDirectoryURL:NSURL? = {
        do {
            return try NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        }
        catch {
            
            print("*** Error finding documents directory: \(error)")
            return nil
        }
    }()
    
    lazy var context:NSManagedObjectContext? = {
       
        guard let url = self.documentsDirectoryURL?.URLByAppendingPathComponent("words.sql"),
            let model = self.managedObjectModel else {
                
            print("An error occured getting sqlite3 file from documents")
            return nil
        }
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        
            let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
            context.persistentStoreCoordinator = coordinator
            
            return context
        } catch {
            
            print("An error occurred creating persistent store coordinator for words: \(error)")
            return nil
        }
    }()
    
    init() {
        
        if self.databaseAvailable() && getWordCount() < 1 {
            
            installDatabase()
        }
        
    }
    
    private func installDatabase() {
        do {
            
            let dataPath = NSBundle.mainBundle().pathForResource("word", ofType: "json")
            print(dataPath)
            let words = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfFile: dataPath!)!, options: NSJSONReadingOptions.AllowFragments)
            
           
            for word in words as! NSArray {
                
                let wc = NSEntityDescription.insertNewObjectForEntityForName("Word", inManagedObjectContext: context!) as? Word
                wc?.word = word["word"] as? String
                wc?.position = word["id"] as? Int
                
            }
            
            
            
            try context!.save()
            
            print("Database installed")
            
        } catch {
            print("Error isntalling database info: \(error)")
        }
        
    }
    
    func databaseAvailable() -> Bool {
        
        return context != nil
    }
    
    func getWordCount() -> Int {
        
        guard let context = self.context else {
            print("No context available at getWordCount()")
            
            return 0
        }
        
        let request = NSFetchRequest(entityName: "Word")
        request.includesSubentities = false
        
        var error: NSError?
        let result = context.countForFetchRequest(request, error: &error)
        
        return result
        
    }
    
    func wordAt(index: Int) -> String {
        
        guard let context = self.context else {
            print("No context available at wordAt(\(index))")
            
            return ""
        }
        
        
        let request = NSFetchRequest(entityName: "Word")
        request.predicate = NSPredicate(format: "position == %d", index)
        
        do {
            
            let words = try context.executeFetchRequest(request) as! [Word]
            if let word = words.first?.word where words.count > 0 {
                return word
            } else {
                
                print("Failed to find word at \(index).")
                return ""
            }
            
        } catch {
            
            print("Failed to fetch word at \(index).")
            return ""
        }
        
    }
}
