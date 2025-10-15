//
//  TasksView.swift
//  Tasky
//
//  Created by Francisco Jean on 02/10/25.
//

import SwiftUI

struct TasksView: View {
    @ObservedObject var viewModel: TasksViewModel
    let selectedProjectID: UUID?

    var body: some View {
        Group {
            if viewModel.filteredTasks.isEmpty {
                ContentUnavailableView(label: {
                    Label("No Tasks", systemImage: "checkmark.circle")
                }, description: {
                    Text("Try selecting a different project or create a new task.")
                })
            } else {
                List {
                    ForEach(viewModel.filteredTasks) { task in
                        HStack {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(task.isCompleted ? .green : .gray)

                            Text(task.title)
                                .font(.body)
                                .opacity(0.7)
                        }
                    }
                    .onMove { indices, newOffset in
                        viewModel.move(from: indices, to: newOffset, selectedProjectID: selectedProjectID)
                    }
                }
                .listStyle(.plain)
                .environment(\.editMode, .constant(.active))
            }
        }
    }
}

#Preview {
    TasksView(
        viewModel: TasksViewModel(tasks: SampleData.sampleTasks),
        selectedProjectID: nil
    )
}
