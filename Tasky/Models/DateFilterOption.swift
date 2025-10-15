import Foundation

enum DateFilterOption: Hashable {
    case anyDate
    case today
    case tomorrow
    case weekend
    case nextWeek
    case specific(Date)

    func matches(date: Date, calendar: Calendar) -> Bool {
        switch self {
        case .anyDate:
            return true
        case .today:
            return calendar.isDateInToday(date)
        case .tomorrow:
            return calendar.isDateInTomorrow(date)
        case .weekend:
            guard let target = Self.resolveUpcomingWeekend(calendar: calendar) else { return false }
            return calendar.isDate(date, inSameDayAs: target)
        case .nextWeek:
            guard let target = Self.resolveWeekdayAfterToday(weekday: 2, calendar: calendar) else { return false }
            return calendar.isDate(date, inSameDayAs: target)
        case .specific(let targetDate):
            return calendar.isDate(date, inSameDayAs: targetDate)
        }
    }

    var isSpecificSelection: Bool {
        if case .specific = self { return true }
        return false
    }

    static let presets: [DateFilterOption] = [.anyDate, .today, .tomorrow, .weekend, .nextWeek]

    private static func resolveUpcomingWeekend(calendar: Calendar) -> Date? {
        let start = calendar.startOfDay(for: Date())
        if calendar.component(.weekday, from: start) == 7 {
            return start
        }

        return calendar.nextDate(
            after: start,
            matching: DateComponents(weekday: 7),
            matchingPolicy: .nextTimePreservingSmallerComponents
        ).map { calendar.startOfDay(for: $0) }
    }

    private static func resolveWeekdayAfterToday(weekday: Int, calendar: Calendar) -> Date? {
        let start = calendar.startOfDay(for: Date())

        return calendar.nextDate(
            after: start,
            matching: DateComponents(weekday: weekday),
            matchingPolicy: .nextTimePreservingSmallerComponents
        ).map { calendar.startOfDay(for: $0) }
    }
}
