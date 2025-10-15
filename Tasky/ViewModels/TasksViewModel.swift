import Foundation
import Combine
import SwiftUI

final class TasksViewModel: ObservableObject {
    @Published private(set) var allTasks: [Task]
    @Published private(set) var filteredTasks: [Task]

    private var currentProjectID: UUID?
    private var currentDateFilter: DateFilterOption = .anyDate
    private let calendar = Calendar.current

    init(tasks: [Task]) {
        let sorted = tasks.sorted { $0.order < $1.order }
        self.allTasks = sorted
        self.filteredTasks = sorted
        applyFilters()
    }

    func updateFilter(selectedProjectID: UUID?) {
        currentProjectID = selectedProjectID
        applyFilters()
    }

    func updateDateFilter(_ filter: DateFilterOption) {
        currentDateFilter = filter
        applyFilters()
    }

    func move(from source: IndexSet, to destination: Int, selectedProjectID: UUID?) {
        var updatedFiltered = filteredTasks
        updatedFiltered.move(fromOffsets: source, toOffset: destination)

        let ordersToReuse: [Int]
        if let projectID = selectedProjectID {
            ordersToReuse = allTasks
                .filter { $0.projectID == projectID }
                .map { $0.order }
                .sorted()
        } else {
            ordersToReuse = allTasks.map { $0.order }.sorted()
        }

        for index in updatedFiltered.indices {
            guard index < ordersToReuse.count else { break }
            updatedFiltered[index].order = ordersToReuse[index]
        }

        if selectedProjectID != nil {
            for updatedTask in updatedFiltered {
                if let allIndex = allTasks.firstIndex(where: { $0.id == updatedTask.id }) {
                    allTasks[allIndex].order = updatedTask.order
                }
            }
        } else {
            allTasks = updatedFiltered
        }

        allTasks.sort { lhs, rhs in
            if lhs.order == rhs.order {
                return lhs.createdAt < rhs.createdAt
            }
            return lhs.order < rhs.order
        }

        updateFilter(selectedProjectID: selectedProjectID)
    }

    private func applyFilters() {
        var tasks = allTasks

        if let projectID = currentProjectID {
            tasks = tasks.filter { $0.projectID == projectID }
        }

        tasks = tasks.filter { currentDateFilter.matches(date: $0.dueDate, calendar: calendar) }

        tasks.sort { lhs, rhs in
            if lhs.order == rhs.order {
                return lhs.createdAt < rhs.createdAt
            }
            return lhs.order < rhs.order
        }

        filteredTasks = tasks
    }
}
