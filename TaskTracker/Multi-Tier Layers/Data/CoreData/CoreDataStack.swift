//
//  CoreDataStack.swift
//  TaskTracker
//
//  Created by VA on 17/01/22.
//

import Foundation
import CoreData

final class CoreDataStack {
    
    private let modelName: String
    init(modelName: String) {
        self.modelName = modelName
    }
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores {
            (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    func saveContext () {
        guard managedContext.hasChanges else { return }
        do {
            try managedContext.save()
        } catch {
            let fetchError = error as NSError
            debugPrint(fetchError)
        }
    }
}
