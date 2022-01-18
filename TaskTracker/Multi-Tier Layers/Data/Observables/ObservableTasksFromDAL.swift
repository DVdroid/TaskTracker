//
//  ObservableTasks.swift
//  TaskTracker
//
//  Created by VA on 17/01/22.
//

import Foundation

final class ObservableTasksFromDAL: NSObject, ObservableObject {
    @Published var tasksFromDAL: [Task] = []
    
    override init() {
        super.init()
    }
}
