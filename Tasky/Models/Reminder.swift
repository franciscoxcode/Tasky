//
//  Reminder.swift
//  Tasky
//
//  Created by Francisco Jean on 30/09/25.
//
import Foundation

struct Reminder: Identifiable {
    let id = UUID()
    var date: Date
    var message: String? = nil
    var isDone: Bool = false
}
