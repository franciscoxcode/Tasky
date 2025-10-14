import Foundation
import Combine
import SwiftUI

final class NotesViewModel: ObservableObject {
    @Published private(set) var allNotes: [Note]
    @Published private(set) var filteredNotes: [Note]

    init(notes: [Note]) {
        let sorted = notes.sorted { $0.order < $1.order }
        self.allNotes = sorted
        self.filteredNotes = sorted
    }

    func updateFilter(selectedProjectID: UUID?) {
        if let projectID = selectedProjectID {
            filteredNotes = allNotes
                .filter { $0.projectID == projectID }
                .sorted { $0.order < $1.order }
        } else {
            filteredNotes = allNotes.sorted { $0.order < $1.order }
        }
    }

    func move(from source: IndexSet, to destination: Int, selectedProjectID: UUID?) {
        var updatedFiltered = filteredNotes
        updatedFiltered.move(fromOffsets: source, toOffset: destination)

        let ordersToReuse: [Int]
        if let projectID = selectedProjectID {
            ordersToReuse = allNotes
                .filter { $0.projectID == projectID }
                .map { $0.order }
                .sorted()
        } else {
            ordersToReuse = allNotes.map { $0.order }.sorted()
        }

        for index in updatedFiltered.indices {
            guard index < ordersToReuse.count else { break }
            updatedFiltered[index].order = ordersToReuse[index]
        }

        if let projectID = selectedProjectID {
            for updatedNote in updatedFiltered {
                if let allIndex = allNotes.firstIndex(where: { $0.id == updatedNote.id }) {
                    allNotes[allIndex].order = updatedNote.order
                }
            }
        } else {
            allNotes = updatedFiltered
        }

        allNotes.sort { lhs, rhs in
            if lhs.order == rhs.order {
                return lhs.createdAt < rhs.createdAt
            }
            return lhs.order < rhs.order
        }

        updateFilter(selectedProjectID: selectedProjectID)
    }
}
