//
//  Relation.swift
//  Tasky
//
//  Created by Francisco Jean on 30/09/25.
//
import Foundation

struct Relation: Identifiable {
    let id = UUID()
    var fromID: UUID
    var toID: UUID
    var type: RelationType
}
