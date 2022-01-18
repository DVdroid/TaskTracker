//
//  TaskListCoordinator.swift
//  TaskTracker
//
//  Created by VA on 17/01/22.
//

import Foundation
import Combine
import UIKit

final class TaskListCoordinator: NSObject {
    
    private var cancellable = Set<AnyCancellable>()
    private lazy var coreDataStack = CoreDataStack(modelName: "TaskTracker")
    
    var tasksDAL: TasksDAL!
    var tasksBLL: TasksBLL!
    var tasksVM: TasksVM!
    
    var sourceVC: UIViewController?
    
    func start(sourceVC: UIViewController) {
        self.sourceVC = sourceVC
        setupTaskList()
        loadTaskListVC()
    }
    
    private func setupTaskList() {
        tasksDAL = TasksDAL(coreDataStack)
        tasksBLL = TasksBLL(tasksDAL: tasksDAL)
        tasksVM = TasksVM(tasksBLL: tasksBLL)
    }
    
    private func loadTaskListVC() {
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: .main)
        let taskListVC = mainStoryBoard.instantiateViewController(identifier: "TaskListViewController") { [unowned self] in
            let observableTaskListDisplayItem = self.tasksVM.observableTaskListDisplayItem
            return TaskListViewController(coder: $0, observableTaskListDisplayItem: observableTaskListDisplayItem)
        }
        sourceVC?.show(taskListVC, sender: self)
    }
    
    func saveContext() {
        coreDataStack.saveContext()
    }
}
