//
//  TasksVM.swift
//  TaskTracker
//
//  Created by VA on 17/01/22.
//

import Foundation
import Combine

final class TasksVM: NSObject {
    
    var tasksBLL: TasksBLL!
    var observableTaskListDisplayItem = ObservableTaskListDisplayItem()
    var observableTasksFromBLL: ObservableTasksFromBLL
    
    private var cancellables = Set<AnyCancellable>()
    
    init(tasksBLL: TasksBLL) {
        self.tasksBLL = tasksBLL
        self.observableTasksFromBLL = tasksBLL.observableTasksFromBLL
        super.init()
        
        observableTasksFromBLL.$tasksFromBLL.sink { [weak self] in
            self?.mapTasksFromBLLToUIModel($0)
        }.store(in: &cancellables)
    }
    
    private func mapTasksFromBLLToUIModel( _ tasksFromBLL: [TaskFromBLL]) {
        
        let taskModel = tasksFromBLL.map {
            TaskModel(id: $0.id, title: $0.name, description: $0.detail, isComplete: $0.isComplete)
        }
        
        let taskListDisplayItem = TaskListDisplayItem(with: taskModel,
                                                      createTapAction: createTapAction,
                                                      updateTapAction: updateTapAction,
                                                      removeTapAction: removeTapAction,
                                                      checkBoxTapAction: checkBoxTapAction
        )
        
        observableTaskListDisplayItem.tasklistDisplayItem = taskListDisplayItem
    }
    
    
    func createTapAction( _ task: TaskModel) {
        tasksBLL.createTask(
            with: task.id,
            name: task.title,
            detail: task.description,
            dateCreated: task.dateCreated,
            isCompleted: task.isComplete
        )
    }
    
    func updateTapAction( _ task: TaskModel) {
        tasksBLL.updateTask(
            with: task.id,
            name: task.title,
            detail: task.description,
            isCompleted: task.isComplete
        )
    }
    
    func removeTapAction( _ task: TaskModel) {
        tasksBLL.deleteTask(with: task.id)
    }
    
    func checkBoxTapAction( _ isChecked: Bool, task: TaskModel) {
        tasksBLL.updateTask(
            with: task.id,
            name: task.title,
            detail: task.description,
            isCompleted: isChecked
        )
    }
}
