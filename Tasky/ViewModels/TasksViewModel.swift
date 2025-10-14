import Foundation
import Combine

final class TasksViewModel: ObservableObject {
    @Published private(set) var allTasks: [Task]
    @Published private(set) var filteredTasks: [Task]

    init(tasks: [Task]) {
        self.allTasks = tasks
        self.filteredTasks = tasks
    }

    func updateFilter(selectedProjectID: UUID?) {
        guard let selectedProjectID else {
            filteredTasks = allTasks
            return
        }

        filteredTasks = allTasks.filter { $0.projectID == selectedProjectID }
    }
}
