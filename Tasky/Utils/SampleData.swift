//
//  SampleData.swift
//  Tasky
//
//  Created by Francisco Jean on 02/10/25.
//

import Foundation
import SwiftUI

struct SampleData {
    static let sampleProjects = [
        Project(emoji: "📚", name: "Study", color: .blue, visibleIn: Set(Project.SectionType.allCases)),
        Project(emoji: "💼", name: "Work", color: .green, visibleIn: [.tasks, .events]),
        Project(emoji: "🏋️", name: "Fitness", color: .red, visibleIn: [.tasks, .events]),
        Project(emoji: nil, name: "Mental Health", color: .yellow, visibleIn: [.notes]),
        Project(emoji: "🍎", name: "Health", color: .pink, visibleIn: [.tasks, .notes]),
        Project(emoji: "✈️", name: "Travel", color: .purple, visibleIn: [.events]),
        Project(emoji: "🎵", name: "Music", color: .orange, visibleIn: [.tasks]),
        Project(emoji: "📖", name: "Reading", color: .indigo, visibleIn: [.notes]),
        Project(emoji: "💻", name: "Coding", color: .teal, visibleIn: [.tasks, .events])
    ]
    
    static let sampleTasks = [
        Task(title: "Finish SwiftUI tutorial", projectID: sampleProjects[0].id, order: 0),
        Task(title: "Prepare meeting slides", projectID: sampleProjects[1].id, order: 1),
        Task(title: "Do 20 push-ups", projectID: sampleProjects[2].id, order: 2)
    ]
    
    static let sampleEvents = [
        Event(emoji: "🎤", title: "iOS Conference", date: Date(), projectID: sampleProjects[1].id, order: 0),
        Event(emoji: "💪", title: "Gym session", date: Date(), projectID: sampleProjects[2].id, order: 1),
        Event(
                   emoji: "🎂",
                   title: "Birthday Party",
                   date: DateComponents(calendar: .current, year: 2025, month: 10, day: 14).date!,
                   projectID: SampleData.sampleProjects.first!.id,
                   order: 0
               ),
        Event(
                  emoji: "🏕️",
                  title: "Camping Trip",
                  date: DateComponents(calendar: .current, year: 2025, month: 10, day: 14).date!,
                  projectID: SampleData.sampleProjects.first!.id,
                  endDate: DateComponents(calendar: .current, year: 2025, month: 10, day: 17).date!,
                  order: 1
              ),
        Event(
                   emoji: "✈️",
                   title: "Trip to Tokyo",
                   date: DateComponents(calendar: .current, year: 2025, month: 11, day: 3).date!,
                   projectID: SampleData.sampleProjects.last!.id,
                   endDate: DateComponents(calendar: .current, year: 2025, month: 12, day: 10).date!,
                   order: 2
               )
    ]
    
    static let sampleNotes = [
        Note(title: "App idea", content: "A fun productivity app!", projectID: sampleProjects[0].id, order: 0),
        Note(title: "Workout tips", content: "Don’t skip leg day!", projectID: sampleProjects[2].id, order: 1)
    ]
}
