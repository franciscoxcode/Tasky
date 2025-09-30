//
//  Task.swift
//  Tasky
//
//  Created by Francisco Jean on 25/09/25.
//

import Foundation

struct Task: Identifiable {
    let id = UUID()
    var title: String
    var isCompleted: Bool = false
    let createdAt = Date()
    var projectID: UUID
    var reminders: [Reminder] = []
}
