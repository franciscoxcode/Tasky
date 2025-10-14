import Foundation
import Combine

final class NotesViewModel: ObservableObject {
    @Published private(set) var allNotes: [Note]
    @Published private(set) var filteredNotes: [Note]

    init(notes: [Note]) {
        self.allNotes = notes
        self.filteredNotes = notes
    }

    func updateFilter(selectedProjectID: UUID?) {
        guard let selectedProjectID else {
            filteredNotes = allNotes
            return
        }

        filteredNotes = allNotes.filter { $0.projectID == selectedProjectID }
    }
}
