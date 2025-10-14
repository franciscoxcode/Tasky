import Foundation
import Combine
import SwiftUI

final class EventsViewModel: ObservableObject {
    @Published private(set) var allEvents: [Event]
    @Published private(set) var filteredEvents: [Event]

    init(events: [Event]) {
        let sorted = events.sorted { $0.order < $1.order }
        self.allEvents = sorted
        self.filteredEvents = sorted
    }

    func updateFilter(selectedProjectID: UUID?) {
        if let projectID = selectedProjectID {
            filteredEvents = allEvents
                .filter { $0.projectID == projectID }
                .sorted { $0.order < $1.order }
        } else {
            filteredEvents = allEvents.sorted { $0.order < $1.order }
        }
    }

    func move(from source: IndexSet, to destination: Int, selectedProjectID: UUID?) {
        var updatedFiltered = filteredEvents
        updatedFiltered.move(fromOffsets: source, toOffset: destination)

        let ordersToReuse: [Int]
        if let projectID = selectedProjectID {
            ordersToReuse = allEvents
                .filter { $0.projectID == projectID }
                .map { $0.order }
                .sorted()
        } else {
            ordersToReuse = allEvents.map { $0.order }.sorted()
        }

        for index in updatedFiltered.indices {
            guard index < ordersToReuse.count else { break }
            updatedFiltered[index].order = ordersToReuse[index]
        }

        if let projectID = selectedProjectID {
            for updatedEvent in updatedFiltered {
                if let allIndex = allEvents.firstIndex(where: { $0.id == updatedEvent.id }) {
                    allEvents[allIndex].order = updatedEvent.order
                }
            }
        } else {
            allEvents = updatedFiltered
        }

        allEvents.sort { lhs, rhs in
            if lhs.order == rhs.order {
                return lhs.date < rhs.date
            }
            return lhs.order < rhs.order
        }

        updateFilter(selectedProjectID: selectedProjectID)
    }
}
