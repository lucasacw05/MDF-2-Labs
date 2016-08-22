//
//  Icarus_CoreDataStack.swift
//  AlencarLucas_CE04
//
//  Created by Lucas Alencar on 8/22/16.
//  Copyright © 2016 Lucas Alencar. All rights reserved.
//

import Foundation
import CoreData


class Icarus_CoreDataStack {
    
    
    //Our "Notepad"
    let context: NSManagedObjectContext!
    
    //The WorkHouse. This coordinates everything between our Objects, Context, and Persistant Store (hard drive)
    let persistentStoreCoordinator: NSPersistentStoreCoordinator!
    
    //We model our data in the .xcdatamodeld file in Xcode
    //We create entities and attributes etc.
    //This property will represent our entire .xdatamodel file once setup
    let objModel: NSManagedObjectModel!
    
    //SQLite? XML? Binary? Reads/Write data in whatever format we choose
    let store: NSPersistentStore?
    
    
    init() {
        
        //1. Setup object model
        let xcDataModelURL = NSBundle.mainBundle().URLForResource("CoreDataDM", withExtension: "momd")
        
        //We're force unwrapping. This will crash if the file path isn't correct. But that's what we want.
        objModel = NSManagedObjectModel(contentsOfURL: xcDataModelURL!)
        
        //2. Use object model to setup StoreCoordinator
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: objModel)
        
        //3. Use StoreCoordinator to setup ObjContext
        context = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        
        
        //4. Use StoreCoordinator to setup PersistantStore
        
        // a. Get the URL to our document directory
        let directories: [NSURL] = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        
        // b. Create a new URL file path in which to save this application's data by appending to the directory path.
        //    This is the rough equivalent of saying "path = Documents/CSStack_Data"
        let storeURL = directories[0].URLByAppendingPathComponent("CDStack_Data")
        
        // c. Create a dictionary of options
        let storeOptions = [NSMigratePersistentStoresAutomaticallyOption: true]
        
        // d. set our store's value
        
        do {
            
            //Sometimes you know a throwing function or method won't, in fact, throw an error at runtime. On those occations, you can write - try! - before the expression to disable error propagation and wrap the call in a runtime assertion that no error will be thrown. If an error actually is thrown, you will get a runtime error
            //That's fine with us. If the Core Data Setup isn't working, crashing will alert us to that fact.
            store = try! persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: storeOptions)
        }
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                //Replace this implementation with code to handle the error appropriately
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

    
}