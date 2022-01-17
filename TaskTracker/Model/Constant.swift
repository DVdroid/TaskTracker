//
//  Constant.swift
//  TaskTracker
//
//  Created by VA on 16/01/22.
//

import Foundation

enum Constant {
    static let checkedImageName = "Checkmark"
    static let uncheckedImageName = "Checkmarkempty"
    
    static let randomText = """
    Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna
    aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure
    dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident,
    sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.
    """
    
    static let tasks: [Task] =
    [ Task(id: UUID().uuidString, title: "1", description: Constant.randomText, isComplete: false),
      Task(id: UUID().uuidString, title: "2", description: Constant.randomText, isComplete: false),
      Task(id: UUID().uuidString, title: "3", description: Constant.randomText, isComplete: false),
      Task(id: UUID().uuidString, title: "4", description: Constant.randomText, isComplete: false)
    ]
    
}
