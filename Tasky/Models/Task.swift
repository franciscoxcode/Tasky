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
    var order: Int

    init(
        title: String,
        isCompleted: Bool = false,
        projectID: UUID,
        reminders: [Reminder] = [],
        order: Int = 0
    ) {
        self.title = title
        self.isCompleted = isCompleted
        self.projectID = projectID
        self.reminders = reminders
        self.order = order
    }
}
