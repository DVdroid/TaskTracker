//
//  ObservableTasksFromBLL.swift
//  TaskTracker
//
//  Created by VA on 17/01/22.
//

import Foundation

final class ObservableTasksFromBLL: NSObject, ObservableObject {
    @Published var tasksFromBLL: [TaskFromBLL] = []
    
    override init() {
        super.init()
    }
}
