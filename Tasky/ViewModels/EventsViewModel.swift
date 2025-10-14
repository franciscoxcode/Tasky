import Foundation
import Combine

final class EventsViewModel: ObservableObject {
    @Published private(set) var allEvents: [Event]
    @Published private(set) var filteredEvents: [Event]

    init(events: [Event]) {
        self.allEvents = events
        self.filteredEvents = events
    }

    func updateFilter(selectedProjectID: UUID?) {
        guard let selectedProjectID else {
            filteredEvents = allEvents
            return
        }

        filteredEvents = allEvents.filter { $0.projectID == selectedProjectID }
    }
}
