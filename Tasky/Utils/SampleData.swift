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
        Task(title: "Finish SwiftUI tutorial", projectID: sampleProjects[0].id),
        Task(title: "Prepare meeting slides", projectID: sampleProjects[1].id),
        Task(title: "Do 20 push-ups", projectID: sampleProjects[2].id)
    ]
    
    static let sampleEvents = [
        Event(emoji: "🎤", title: "iOS Conference", date: Date(), projectID: sampleProjects[1].id),
        Event(emoji: "💪", title: "Gym session", date: Date(), projectID: sampleProjects[2].id)
    ]
    
    static let sampleNotes = [
        Note(title: "App idea", content: "A fun productivity app!", projectID: sampleProjects[0].id),
        Note(title: "Workout tips", content: "Don’t skip leg day!", projectID: sampleProjects[2].id)
    ]
}
