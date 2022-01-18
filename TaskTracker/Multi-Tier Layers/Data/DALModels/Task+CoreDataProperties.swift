//
//  Task+CoreDataProperties.swift
//  TaskTracker
//
//  Created by VA on 17/01/22.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var detail: String?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var isComplete: Bool

}

extension Task : Identifiable {

}
