//
//  ObservableTaskListDisplayItem.swift
//  TaskTracker
//
//  Created by VA on 16/01/22.
//

import Foundation
import Combine

final public class ObservableTaskListDisplayItem: NSObject, ObservableObject {
    @Published var tasklistDisplayItem: TaskListDisplayItem = TaskListDisplayItem(with: [])
    
    override public init() {
        super.init()
    }
}
