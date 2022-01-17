//
//  Task.swift
//  TaskTracker
//
//  Created by VA on 16/01/22.
//

import Foundation

public struct Task: Identifiable, Hashable {
    public let id: String
    let title: String
    var description: String? = nil
    var isComplete: Bool = false
    let dateCreated: Date = Date()
}
