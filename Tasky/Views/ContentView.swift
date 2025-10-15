//
//  ContentView.swift
//  Tasky
//
//  Created by Francisco Jean on 23/09/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("selectedTab") private var selectedTab: Tab = .tasks

    @State private var projects: [Project] = SampleData.sampleProjects
    @State private var showNewProject = false
    @State private var editingProject: Project? = nil
    @State private var selectedProjectID: UUID? = nil
    @State private var eventsDateFilter: DateFilterOption = .anyDate
    @State private var tasksDateFilter: DateFilterOption = .anyDate
    @State private var isShowingDatePicker = false
    @State private var activeDatePickerTab: Tab?
    @State private var tempPickedDate = Date()
    @StateObject private var tasksViewModel = TasksViewModel(tasks: SampleData.sampleTasks)
    @StateObject private var eventsViewModel = EventsViewModel(events: SampleData.sampleEvents)
    @StateObject private var notesViewModel = NotesViewModel(notes: SampleData.sampleNotes)

    private var currentSection: Project.SectionType {
        switch selectedTab {
        case .events: return .events
        case .tasks:  return .tasks
        case .notes:  return .notes
        }
    }

    enum Tab: String {
        case events, tasks, notes
    }

    var body: some View {
        VStack {
            NavigationBarView(
                projects: $projects,
                section: currentSection,
                selectedProjectID: $selectedProjectID,
                onTapNew: { showNewProject = true },
                onEdit: { project in
                    editingProject = project
                }
            )

            if selectedTab == .events {
                DateFilterBar(
                    selectedFilter: eventsDateFilter,
                    onSelect: { eventsDateFilter = $0 },
                    onPickDate: { presentDatePicker(for: .events) }
                )
                .padding(.top, 12)
            } else if selectedTab == .tasks {
                DateFilterBar(
                    selectedFilter: tasksDateFilter,
                    onSelect: { tasksDateFilter = $0 },
                    onPickDate: { presentDatePicker(for: .tasks) }
                )
                .padding(.top, 12)
                .padding(.bottom, 14)
            }

            TabView(selection: $selectedTab) {
                EventsView(
                    viewModel: eventsViewModel,
                    selectedProjectID: selectedProjectID
                )
                    .tabItem { Label("Events", systemImage: "calendar") }
                    .tag(Tab.events)

                TasksView(
                    viewModel: tasksViewModel,
                    selectedProjectID: selectedProjectID
                )
                    .tabItem { Label("Tasks", systemImage: "checkmark.circle") }
                    .tag(Tab.tasks)

                NotesView(
                    viewModel: notesViewModel,
                    selectedProjectID: selectedProjectID
                )
                    .tabItem { Label("Notes", systemImage: "note.text") }
                    .tag(Tab.notes)
            }
        }
        .overlay {
            // Overlay para crear nuevo proyecto
            if showNewProject {
                ZStack {
                    Color.black.opacity(0.35)
                        .ignoresSafeArea()
                        .onTapGesture { showNewProject = false }

                    NewProjectView(
                        onSave: { newProject in
                            projects.append(newProject)
                            showNewProject = false
                        },
                        onCancel: {
                            showNewProject = false
                        }
                    )
                    .padding()
                    .transition(.scale)
                }
            }

            // Overlay para editar proyecto existente
            if let projectToEdit = editingProject {
                ZStack {
                    Color.black.opacity(0.35)
                        .ignoresSafeArea()
                        .onTapGesture { editingProject = nil }

                    NewProjectView(
                        existingProject: projectToEdit,
                        onSave: { updatedProject in
                            if let index = projects.firstIndex(where: { $0.id == updatedProject.id }) {
                                projects[index] = updatedProject
                            }
                            editingProject = nil
                        },
                        onDelete: {
                            projects.removeAll { $0.id == projectToEdit.id }
                            if selectedProjectID == projectToEdit.id {
                                selectedProjectID = nil
                            }
                            editingProject = nil
                        }, onCancel: {
                            editingProject = nil
                        }
                    )
                    .padding()
                    .transition(.scale)
                }
            }
        }
        .animation(.easeInOut, value: showNewProject)
        .animation(.easeInOut, value: editingProject)
        .onChange(of: selectedProjectID) { _, newValue in
            tasksViewModel.updateFilter(selectedProjectID: newValue)
            eventsViewModel.updateFilter(selectedProjectID: newValue)
            notesViewModel.updateFilter(selectedProjectID: newValue)
        }
        .onChange(of: selectedTab) { _, _ in
            guard
                let selectedID = selectedProjectID,
                let project = projects.first(where: { $0.id == selectedID })
            else { return }

            if project.visibleIn.contains(currentSection) == false {
                selectedProjectID = nil
            }
        }
        .onChange(of: eventsDateFilter) { _, newValue in
            eventsViewModel.updateDateFilter(newValue)
        }
        .onChange(of: tasksDateFilter) { _, newValue in
            tasksViewModel.updateDateFilter(newValue)
        }
        .sheet(isPresented: $isShowingDatePicker) {
            NavigationStack {
                VStack(alignment: .leading, spacing: 16) {
                    DatePicker(
                        "Select Date",
                        selection: $tempPickedDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .padding()
                }
                .navigationTitle("Pick a Date")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { cancelDatePicker() }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Apply") { applyPickedDate() }
                    }
                }
            }
            .presentationDetents([.medium])
        }
    }

    private func presentDatePicker(for tab: Tab) {
        activeDatePickerTab = tab
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        switch tab {
        case .events:
            if case let .specific(date) = eventsDateFilter {
                tempPickedDate = date
            } else {
                tempPickedDate = today
            }
        case .tasks:
            if case let .specific(date) = tasksDateFilter {
                tempPickedDate = date
            } else {
                tempPickedDate = today
            }
        case .notes:
            tempPickedDate = today
        }

        isShowingDatePicker = true
    }

    private func cancelDatePicker() {
        isShowingDatePicker = false
        activeDatePickerTab = nil
    }

    private func applyPickedDate() {
        guard let tab = activeDatePickerTab else {
            cancelDatePicker()
            return
        }

        let calendar = Calendar.current
        let normalizedDate = calendar.startOfDay(for: tempPickedDate)
        let filter = DateFilterOption.specific(normalizedDate)

        switch tab {
        case .events:
            eventsDateFilter = filter
        case .tasks:
            tasksDateFilter = filter
        case .notes:
            break
        }

        isShowingDatePicker = false
        activeDatePickerTab = nil
    }
}

#Preview {
    ContentView()
}
