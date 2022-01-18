//
//  TasksDAL.swift
//  TaskTracker
//
//  Created by VA on 17/01/22.
//

import Foundation
import CoreData

final class TasksDAL {
    
    var observableTasksFromDAL = ObservableTasksFromDAL()
    private let coreDataStack: CoreDataStack
    
    init(_ coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    private var managedContext: NSManagedObjectContext {
        coreDataStack.managedContext
    }
    
    //======================== CURD Operations =========================//
    
    //Create
    func createTask(with id: UUID,
                    name: String,
                    detail: String?,
                    dateCreated: Date,
                    isCompleted: Bool) {
        
        if let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: managedContext) {
            let task = Task(entity: entityDescription, insertInto: managedContext)
            task.id = id
            task.name = name
            task.detail = detail
            task.isComplete = isCompleted
            task.dateCreated = dateCreated
            coreDataStack.saveContext()
            
            refresh()
        }
    }
    
    //Update
    func updateTask(with id: UUID,
                    name: String,
                    detail: String?,
                    isCompleted: Bool) {
        
        let request = Task.fetchRequest()
        request.predicate = NSPredicate(format: "%K = %@", "id", id as CVarArg)
        
        do {
            if let matchedTask = try managedContext.fetch(request).first {
                matchedTask.name = name
                matchedTask.detail = detail
                matchedTask.isComplete = isCompleted
                coreDataStack.saveContext()
                
                refresh()
            }
        } catch {
            let fetchError = error as NSError
            debugPrint(fetchError)
        }
    }
    
    //Read
    func fetchAllTasks() {
        let request = Task.fetchRequest()
        do {
            let allTasks = try managedContext.fetch(request)
            observableTasksFromDAL.tasksFromDAL = allTasks
        } catch {
            let fetchError = error as NSError
            debugPrint(fetchError)
        }
    }
    
    
    //Delete
    func deleteTask(with id: UUID) {
        let request = Task.fetchRequest()
        request.predicate = NSPredicate(format: "%K = %@", "id", id as CVarArg)
        do {
            if let matchedTask = try managedContext.fetch(request).first {
                managedContext.delete(matchedTask)
                coreDataStack.saveContext()
                
                refresh()
            }
        } catch {
            let fetchError = error as NSError
            debugPrint(fetchError)
        }
    }
    
    //======================== CURD Operations =========================//
    
    private func refresh() {
        do {
            let allTasks = try managedContext.fetch(Task.fetchRequest())
            observableTasksFromDAL.tasksFromDAL = allTasks
        } catch {
            let fetchError = error as NSError
            debugPrint(fetchError)
        }
    }
}
