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
    @State private var inlineDatePickerTab: Tab?
    @State private var inlinePickedDate = Date()
    @State private var shouldIgnoreNextDateChange = false
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
                    onSelect: { selectDateFilter($0, for: .events) },
                    onPickDate: { toggleInlineDatePicker(for: .events) }
                )
                .padding(.top, 12)
                .padding(.bottom, inlineDatePickerTab == .events ? 0 : 14)
                inlineDatePicker(for: .events)
            } else if selectedTab == .tasks {
                DateFilterBar(
                    selectedFilter: tasksDateFilter,
                    onSelect: { selectDateFilter($0, for: .tasks) },
                    onPickDate: { toggleInlineDatePicker(for: .tasks) }
                )
                .padding(.top, 12)
                .padding(.bottom, inlineDatePickerTab == .tasks ? 0 : 14)
                inlineDatePicker(for: .tasks)
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
        .onChange(of: selectedTab) { _, newTab in
            guard
                let selectedID = selectedProjectID,
                let project = projects.first(where: { $0.id == selectedID })
            else { return }

            if project.visibleIn.contains(currentSection) == false {
                selectedProjectID = nil
            }

            if inlineDatePickerTab != newTab {
                inlineDatePickerTab = nil
            }
        }
        .onChange(of: eventsDateFilter) { _, newValue in
            eventsViewModel.updateDateFilter(newValue)
        }
        .onChange(of: tasksDateFilter) { _, newValue in
            tasksViewModel.updateDateFilter(newValue)
        }
    }

    private func selectDateFilter(_ filter: DateFilterOption, for tab: Tab) {
        switch tab {
        case .events:
            eventsDateFilter = filter
        case .tasks:
            tasksDateFilter = filter
        case .notes:
            break
        }

        if filter.isSpecificSelection == false, inlineDatePickerTab == tab {
            inlineDatePickerTab = nil
            shouldIgnoreNextDateChange = false
        }
    }

    private func toggleInlineDatePicker(for tab: Tab) {
        if inlineDatePickerTab == tab {
            inlineDatePickerTab = nil
            shouldIgnoreNextDateChange = false
            return
        }

        inlineDatePickerTab = tab

        let calendar = Calendar.current
        let defaultDate = calendar.startOfDay(for: Date())
        let currentFilter = dateFilter(for: tab)
        let targetDate: Date

        if case let .specific(date) = currentFilter {
            targetDate = date
        } else {
            targetDate = defaultDate
        }

        if inlinePickedDate != targetDate {
            shouldIgnoreNextDateChange = true
            inlinePickedDate = targetDate
        } else {
            shouldIgnoreNextDateChange = false
        }
    }

    @ViewBuilder
    private func inlineDatePicker(for tab: Tab) -> some View {
        if inlineDatePickerTab == tab {
            DatePicker(
                "",
                selection: $inlinePickedDate,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .labelsHidden()
            .padding(.horizontal, 20)
            .padding(.top, 4)
            .padding(.bottom, 14)
            .onChange(of: inlinePickedDate) { _, newValue in
                handleInlineDateSelection(newValue, for: tab)
            }
        }
    }

    private func handleInlineDateSelection(_ date: Date, for tab: Tab) {
        if shouldIgnoreNextDateChange {
            shouldIgnoreNextDateChange = false
            return
        }

        applyInlinePickedDate(date, for: tab)
    }

    private func applyInlinePickedDate(_ date: Date, for tab: Tab) {
        let calendar = Calendar.current
        let normalized = calendar.startOfDay(for: date)
        selectDateFilter(.specific(normalized), for: tab)
        inlineDatePickerTab = nil
    }

    private func dateFilter(for tab: Tab) -> DateFilterOption {
        switch tab {
        case .events:
            return eventsDateFilter
        case .tasks:
            return tasksDateFilter
        case .notes:
            return .anyDate
        }
    }
}

#Preview {
    ContentView()
}
