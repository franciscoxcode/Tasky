//
//  TasksView.swift
//  Tasky
//
//  Created by Francisco Jean on 02/10/25.
//

import SwiftUI

struct TasksView: View {
    @ObservedObject var viewModel: TasksViewModel

    var body: some View {
        Group {
            if viewModel.filteredTasks.isEmpty {
                ContentUnavailableView(label: {
                    Label("No Tasks", systemImage: "checkmark.circle")
                }, description: {
                    Text("Try selecting a different project or create a new task.")
                })
            } else {
                List(viewModel.filteredTasks) { task in
                    HStack {
                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(task.isCompleted ? .green : .gray)

                        Text(task.title)
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

#Preview {
    TasksView(viewModel: TasksViewModel(tasks: SampleData.sampleTasks))
}
