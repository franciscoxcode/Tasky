//
//  ContentView.swift
//  Tasky
//
//  Created by Francisco Jean on 23/09/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView () {
            EventsView()
                .tabItem {
                    Label("Events", systemImage: "calendar")
                }

            TasksView()
                .tabItem {
                    Label("Tasks", systemImage: "checkmark.circle")
                }

            NotesView()
                .tabItem {
                    Label("Notes", systemImage: "note.text")
                }
        }
    }
}

#Preview {
    ContentView()
}
