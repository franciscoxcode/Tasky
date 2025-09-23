//
//  Item.swift
//  Tasky
//
//  Created by Francisco Jean on 23/09/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
