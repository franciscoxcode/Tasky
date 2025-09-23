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
        ZStack {
            TabView {
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
                Spacer()
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Menu {
                        Button("New Note") { print("Create Note tapped") }
                        Button("New Task") { print("Create Task tapped") }
                        Button("New Event") { print("Create Event tapped") }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.accentColor)
                            .background(
                                Circle()
                                    .fill(Color(.systemBackground))
                                    .frame(width: 70, height: 70)
                            )
                            .shadow(radius: 5)
                    }
                    .padding(.trailing, 45)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
