//
//  DataController.swift
//  VirtualTourist
//
//  Created by Faisal Babkoor on 12/5/19.
//  Copyright © 2019 Faisal Babkoor. All rights reserved.
//

import CoreData
class DataController {
    static let shared = DataController()
    private let container:NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    var backgorundContext: NSManagedObjectContext!
    private init() {
        container = NSPersistentContainer(name: "VirtualTourist")
    }
    func load(completionHandler: (() -> Void)? = nil) {
        container.loadPersistentStores { (persistentStoreDescription, error) in
               if error != nil {
                     fatalError("Can't load data")
                 }
            self.atuoSave()
            self.configureContext()
                 completionHandler?()
        }
    }
    func configureContext() {
        backgorundContext = container.newBackgroundContext()
        
        viewContext.automaticallyMergesChangesFromParent = true
        backgorundContext.automaticallyMergesChangesFromParent = true
        
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        backgorundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
}
extension DataController {
    func atuoSave(timeInterval: TimeInterval = 30) {
        if timeInterval > 0 {
            if viewContext.hasChanges {
                try? viewContext.save()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
                self.atuoSave(timeInterval: timeInterval)
            }
        } else {
            print("cannot set negative autosave interval")
        }
    }
}
