//
//  TasksFromBLL.swift
//  TaskTracker
//
//  Created by VA on 17/01/22.
//

import Foundation

struct TaskFromBLL {
    let id: UUID
    let name: String
    var detail: String?
    let dateCreated: Date
    var isComplete: Bool
}
