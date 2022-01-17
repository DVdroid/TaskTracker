//
//  TaskViewModel.swift
//  TaskTracker
//
//  Created by VA on 16/01/22.
//

import Foundation

final public class TaskListDisplayItem: NSObject {
    
    let tasks: [Task]
    var saveTapAction:((Task)->Void)?
    var updateTapAction:((Task)->Void)?
    var removeTapAction:((Task)->Void)?
    var checkBoxTapAction:((Task)->Void)?
    
    init(with tasks: [Task],
         saveTapAction: ((Task)->Void)? = nil,
         updateTapAction: ((Task)->Void)? = nil,
         removeTapAction: ((Task)->Void)? = nil,
         checkBoxTapAction: ((Task)->Void)? = nil) {
        self.tasks = tasks
        self.saveTapAction = saveTapAction
        self.updateTapAction = updateTapAction
        self.removeTapAction = removeTapAction
        self.checkBoxTapAction = checkBoxTapAction
    }
}
