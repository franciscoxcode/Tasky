//
//  Project.swift
//  Tasky
//
//  Created by Francisco Jean on 25/09/25.
//

import Foundation
import SwiftUI

struct Project: Identifiable {
    let id = UUID()
    var emoji: Character
    var name: String
    var color: Color
    
    // Lista de posibles emojis por defecto
    private static var availableEmojis: [Character] = ["🦄", "✏️", "👽", "🧠", "🍪", "👾", "👑", "🪿", "🐠", "🍔"]
    
    // Set para llevar control de los ya usados
    private static var usedEmojis: Set<Character> = []
    
    init(emoji: Character? = nil, name: String, color: Color) {
        if let e = emoji, e.unicodeScalars.first?.properties.isEmojiPresentation == true {
            self.emoji = e
            Project.usedEmojis.insert(e)
        } else {
            // Si no hay emoji válido → escoger uno aleatorio que no esté usado
            let unused = Project.availableEmojis.filter { !Project.usedEmojis.contains($0) }
            if let randomEmoji = unused.randomElement() {
                self.emoji = randomEmoji
                Project.usedEmojis.insert(randomEmoji)
            } else {
                self.emoji = "📦" //fallback
            }
        }
        
        self.name = name
        self.color = color
    }
}
