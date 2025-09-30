//
//  Event.swift
//  Tasky
//
//  Created by Francisco Jean on 30/09/25.
//
import Foundation

struct Event: Identifiable {
    let id = UUID()
    var title: String
    var emoji: Character
    var date: Date
    var endDate: Date? = nil
    var projectID: UUID
    
    var reminders: [Reminder] = []
    
    init(
        emoji: Character? = nil,
        title: String,
        date: Date,
        projectID: UUID,
        endDate: Date? = nil
    ) {
        if let e = emoji, e.unicodeScalars.first?.properties.isEmojiPresentation == true {
            self.emoji = e
        } else {
            self.emoji = "📅"
        }
        
        self.title = title
        self.date = date
        self.projectID = projectID
        self.endDate = endDate
    }
}

