//
//  Note.swift
//  Tasky
//
//  Created by Francisco Jean on 30/09/25.
//
import Foundation

struct Note: Identifiable {
    let id = UUID()
    var title: String? = nil
    var content: String
    let createdAt = Date()
    var updatedAt = Date()
    var projectID: UUID
    var order: Int

    init(
        title: String? = nil,
        content: String,
        projectID: UUID,
        order: Int = 0
    ) {
        self.title = title
        self.content = content
        self.projectID = projectID
        self.order = order
    }
}
