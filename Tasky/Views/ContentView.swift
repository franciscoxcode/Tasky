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

            TabView(selection: $selectedTab) {
                EventsView()
                    .tabItem { Label("Events", systemImage: "calendar") }
                    .tag(Tab.events)

                TasksView()
                    .tabItem { Label("Tasks", systemImage: "checkmark.circle") }
                    .tag(Tab.tasks)

                NotesView()
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
    }
}

#Preview {
    ContentView()
}
