//
//  TaskModel.swift
//  TaskTracker
//
//  Created by VA on 16/01/22.
//

import Foundation

struct TaskModel: Identifiable, Hashable {
    let id: UUID
    let title: String
    var description: String? = nil
    var isComplete: Bool = false
    let dateCreated: Date = Date()
}
