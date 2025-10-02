//
//  ContentView.swift
//  Tasky
//
//  Created by Francisco Jean on 23/09/25.
//

import SwiftUI

struct ContentView: View {
    // Guardamos qué pestaña está seleccionada
    @AppStorage("selectedTab") private var selectedTab: Tab = .tasks
    
    enum Tab: String {
        case events, tasks, notes
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            EventsView()
                .tabItem {
                    Label("Events", systemImage: "calendar")
                }
                .tag(Tab.events)
            
            TasksView()
                .tabItem {
                    Label("Tasks", systemImage: "checkmark.circle")
                }
                .tag(Tab.tasks)
            
            NotesView()
                .tabItem {
                    Label("Notes", systemImage: "note.text")
                }
                .tag(Tab.notes)
        }
    }
}

#Preview {
    ContentView()
}
 
