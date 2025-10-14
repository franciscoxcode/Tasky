import Foundation
import Combine
import SwiftUI

final class TasksViewModel: ObservableObject {
    @Published private(set) var allTasks: [Task]
    @Published private(set) var filteredTasks: [Task]

    init(tasks: [Task]) {
        let sorted = tasks.sorted { $0.order < $1.order }
        self.allTasks = sorted
        self.filteredTasks = sorted
    }

    func updateFilter(selectedProjectID: UUID?) {
        if let projectID = selectedProjectID {
            filteredTasks = allTasks
                .filter { $0.projectID == projectID }
                .sorted { $0.order < $1.order }
        } else {
            filteredTasks = allTasks.sorted { $0.order < $1.order }
        }
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

        if let projectID = selectedProjectID {
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
}
