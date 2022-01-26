//
//  ObservableTaskListDisplayItem.swift
//  TaskTracker
//
//  Created by VA on 16/01/22.
//

import Foundation

final class ObservableTaskListDisplayItem: NSObject, ObservableObject {
    @Published var tasklistDisplayItem: TaskListDisplayItem = TaskListDisplayItem(with: [])
    
    override init() {
        super.init()
    }
}
