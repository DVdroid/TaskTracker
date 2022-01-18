//
//  TaskViewModel.swift
//  TaskTracker
//
//  Created by VA on 16/01/22.
//

import Foundation

final public class TaskListDisplayItem: NSObject {
    
    let tasks: [TaskModel]
    var createTapAction:((TaskModel)->Void)?
    var updateTapAction:((TaskModel)->Void)?
    var removeTapAction:((TaskModel)->Void)?
    var checkBoxTapAction:((Bool, TaskModel)->Void)?
    
    init(with tasks: [TaskModel],
         createTapAction: ((TaskModel)->Void)? = nil,
         updateTapAction: ((TaskModel)->Void)? = nil,
         removeTapAction: ((TaskModel)->Void)? = nil,
         checkBoxTapAction: ((Bool, TaskModel)->Void)? = nil) {
        self.tasks = tasks
        self.createTapAction = createTapAction
        self.updateTapAction = updateTapAction
        self.removeTapAction = removeTapAction
        self.checkBoxTapAction = checkBoxTapAction
    }
}
