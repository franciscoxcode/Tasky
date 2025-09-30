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
    var emoji: Character?
    var name: String
    var color: Color
    
    init(emoji: Character, name: String, color: Color) {
        guard emoji.unicodeScalars.first?.properties.isEmojiPresentation == true else {
            fatalError("Project emoji must be an emoji, got: \(emoji)")
        }
        
        self.emoji = emoji
        self.name = name
        self.color = color
    }
}

