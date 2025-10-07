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
        .safeAreaInset(edge: .top) {
            ProjectsBar(
                projects: projects,
                section: currentSection,
                onTapNew: { showNewProject = true }
            )
            .padding(.top, 8)
            .padding(.bottom, 4)
        }
        .overlay {
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
        }
        .animation(.easeInOut, value: showNewProject)
    }
}

#Preview {
    ContentView()
}
 
