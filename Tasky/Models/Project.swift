//
//  Project.swift
//  Tasky
//
//  Created by Francisco Jean on 25/09/25.
//

import Foundation
import SwiftUI

struct Project: Identifiable {
    
    enum SectionType: String, CaseIterable, Hashable {
        case events, tasks, notes
    }
    
    let id = UUID()
    var emoji: Character
    var name: String
    var color: Color
    var visibleIn: Set<SectionType> = [.events, .tasks, .notes]
    var order: Int = 0
    
    
    // Lista de posibles emojis por defecto
    private static var availableEmojis: [Character] = ["🦄", "✏️", "👽", "🧠", "🍪", "👾", "👑", "🪿", "🐠", "🍔"]
    
    // Set para llevar control de los ya usados
    private static var usedEmojis: Set<Character> = []
    
    init(
        emoji: Character? = nil,
        name: String,
        color: Color,
        visibleIn: Set<SectionType> = [.events, .tasks, .notes],
    ) {
        if let e = emoji, e.unicodeScalars.first?.properties.isEmojiPresentation == true {
            self.emoji = e
            Project.usedEmojis.insert(e)
        } else {
            let unused = Project.availableEmojis.filter { !Project.usedEmojis.contains($0) }
            if let randomEmoji = unused.randomElement() {
                self.emoji = randomEmoji
                Project.usedEmojis.insert(randomEmoji)
            } else {
                self.emoji = "📦"
            }
        }

        self.name = name
        self.color = color
        self.visibleIn = visibleIn
    }
}
