import Foundation
import Combine

final class EventsViewModel: ObservableObject {
    struct EventSection: Identifiable {
        let date: Date
        let title: String
        let events: [Event]

        var id: Date { date }
    }

    @Published private(set) var allEvents: [Event]
    @Published private(set) var filteredEvents: [Event]
    @Published private(set) var groupedSections: [EventSection] = []

    private let calendar = Calendar.current
    private let headerFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    private let dateDetailFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    init(events: [Event]) {
        let sorted = events.sorted(by: Self.eventComparator)
        self.allEvents = sorted
        self.filteredEvents = sorted
        self.groupedSections = Self.buildSections(from: sorted, calendar: calendar, headerFormatter: headerFormatter)
    }

    func updateFilter(selectedProjectID: UUID?) {
        if let projectID = selectedProjectID {
            filteredEvents = allEvents
                .filter { $0.projectID == projectID }
                .sorted(by: Self.eventComparator)
            groupedSections = []
        } else {
            filteredEvents = allEvents.sorted(by: Self.eventComparator)
            groupedSections = Self.buildSections(from: filteredEvents, calendar: calendar, headerFormatter: headerFormatter)
        }
    }

    func detailText(for event: Event) -> String {
        let start = event.date

        if event.isAllDay {
            if let endDate = event.endDate,
               calendar.isDate(start, inSameDayAs: endDate) == false {
                return untilText(for: endDate, includeTime: false)
            }
            return "All Day"
        }

        if let endDate = event.endDate {
            if calendar.isDate(start, inSameDayAs: endDate) {
                let startText = timeFormatter.string(from: start)
                let endText = timeFormatter.string(from: endDate)
                return "\(startText) – \(endText)"
            } else {
                return untilText(for: endDate, includeTime: true)
            }
        }

        return timeFormatter.string(from: start)
    }

    private static func eventComparator(_ lhs: Event, _ rhs: Event) -> Bool {
        let calendar = Calendar.current
        let lhsDay = calendar.startOfDay(for: lhs.date)
        let rhsDay = calendar.startOfDay(for: rhs.date)

        if lhsDay == rhsDay {
            if lhs.isAllDay != rhs.isAllDay {
                return lhs.isAllDay && !rhs.isAllDay
            }
            return lhs.date < rhs.date
        }

        return lhs.date < rhs.date
    }

    private static func buildSections(
        from events: [Event],
        calendar: Calendar,
        headerFormatter: DateFormatter
    ) -> [EventSection] {
        var grouped: [Date: [Event]] = [:]
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: startOfToday)

        for event in events {
            let day = calendar.startOfDay(for: event.date)
            grouped[day, default: []].append(event)
        }

        let sortedKeys = grouped.keys.sorted()

        return sortedKeys.map { date in
            let eventsForDay = grouped[date]?.sorted(by: Self.eventComparator) ?? []
            var title = headerFormatter.string(from: date)

            if calendar.isDate(date, inSameDayAs: startOfToday) {
                title += " (Today)"
            } else if let tomorrow = startOfTomorrow, calendar.isDate(date, inSameDayAs: tomorrow) {
                title += " (Tomorrow)"
            }

            return EventSection(date: date, title: title, events: eventsForDay)
        }
    }

    private func untilText(for endDate: Date, includeTime: Bool) -> String {
        var text = dateDetailFormatter.string(from: endDate)
        if includeTime {
            let time = timeFormatter.string(from: endDate)
            text += " • \(time)"
        }
        return "Until \(text)"
    }
}
