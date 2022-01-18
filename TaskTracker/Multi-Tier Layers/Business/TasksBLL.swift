//
//  TasksBLL.swift
//  TaskTracker
//
//  Created by VA on 17/01/22.
//

import Foundation
import Combine

final class TasksBLL: NSObject {
    
    var tasksDAL: TasksDAL!
    var observableTasksFromDAL = ObservableTasksFromDAL()
    var observableTasksFromBLL = ObservableTasksFromBLL()
    private var cancellables = Set<AnyCancellable>()
    
    init(tasksDAL: TasksDAL) {
        self.tasksDAL = tasksDAL
        self.observableTasksFromDAL = tasksDAL.observableTasksFromDAL
        super.init()
        
        observableTasksFromDAL.$tasksFromDAL.sink { [weak self] in
            self?.mapTasksFromDALToTaskFromBLL($0)
        }.store(in: &cancellables)
        
        fetchTaskList()
    }
    
    private func mapTasksFromDALToTaskFromBLL( _ tasksFromDAL: [Task]) {
        
        let tasks = tasksFromDAL.map {
            TaskFromBLL(id: $0.id ?? UUID(),
                        name: $0.name ?? "New Task",
                        detail: $0.detail,
                        dateCreated: $0.dateCreated ?? Date(),
                        isComplete: $0.isComplete
            )
        }
        
        observableTasksFromBLL.tasksFromBLL = tasks
    }
    
    func createTask(with id: UUID,
                    name: String,
                    detail: String?,
                    dateCreated: Date,
                    isCompleted: Bool) {
        tasksDAL.createTask(with: id, name: name, detail: detail, dateCreated: dateCreated, isCompleted: isCompleted)
    }
    
    func updateTask(with id: UUID,
                    name: String,
                    detail: String?,
                    isCompleted: Bool) {
        tasksDAL.updateTask(with: id, name: name, detail: detail, isCompleted: isCompleted)
    }
    
    private func fetchTaskList() {
        tasksDAL.fetchAllTasks()
    }
    
    func deleteTask(with id: UUID) {
        tasksDAL.deleteTask(with: id)
    }
}
