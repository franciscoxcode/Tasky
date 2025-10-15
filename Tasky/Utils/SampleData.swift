//
//  SampleData.swift
//  Tasky
//
//  Created by Francisco Jean on 02/10/25.
//

import Foundation
import SwiftUI

@MainActor
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
        Event(
            emoji: "🎤",
            title: "iOS Conference",
            date: SampleData.makeDate(daysFromToday: 0, hour: 0, minute: 0),
            projectID: sampleProjects[1].id,
            endDate: SampleData.makeDate(daysFromToday: 0, hour: 23, minute: 59),
            isAllDay: true,
            order: 0
        ),
        Event(
            emoji: "☕️",
            title: "Coffee with team",
            date: SampleData.makeDate(daysFromToday: 0, hour: 9, minute: 30),
            projectID: sampleProjects[1].id,
            endDate: SampleData.makeDate(daysFromToday: 0, hour: 10, minute: 30),
            order: 1
        ),
        Event(
            emoji: "💪",
            title: "Gym session",
            date: SampleData.makeDate(daysFromToday: 1, hour: 18, minute: 0),
            projectID: sampleProjects[2].id,
            endDate: SampleData.makeDate(daysFromToday: 1, hour: 19, minute: 0),
            order: 2
        ),
        Event(
            emoji: "🎂",
            title: "Birthday Party",
            date: SampleData.makeDate(daysFromToday: 2, hour: 20, minute: 0),
            projectID: sampleProjects[0].id,
            endDate: SampleData.makeDate(daysFromToday: 2, hour: 23, minute: 0),
            order: 3
        ),
        Event(
            emoji: "🏕️",
            title: "Camping trip",
            date: SampleData.makeDate(daysFromToday: 3, hour: 8, minute: 0),
            projectID: sampleProjects[5].id, // por ejemplo, el de Travel
            endDate: SampleData.makeDate(daysFromToday: 5, hour: 18, minute: 0),
            order: 4
        )
    ]
    
    static let sampleNotes = [
        Note(title: "App idea", content: "A fun productivity app!", projectID: sampleProjects[0].id, order: 0),
        Note(title: "Workout tips", content: "Don’t skip leg day!", projectID: sampleProjects[2].id, order: 1)
    ]
}

extension SampleData {
    private static func makeDate(daysFromToday: Int, hour: Int, minute: Int) -> Date {
        let calendar = Calendar.current
        let now = Date()
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        if let day = components.day {
            components.day = day + daysFromToday
        }
        components.hour = hour
        components.minute = minute
        components.second = 0
        return calendar.date(from: components) ?? now
    }

    private static func makeDate(daysFromToday: Int) -> Date {
        makeDate(daysFromToday: daysFromToday, hour: 0, minute: 0)
    }
}
