//
//  NavigationBarView.swift
//  Tasky
//
//  Created by Francisco Jean on 08/10/25.
//

import SwiftUI

struct NavigationBarView: View {
    @Binding var projects: [Project]
    let section: Project.SectionType
    var onTapNew: () -> Void
    @State private var showReorderSheet = false
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    showReorderSheet = true
                }) {
                    Image(systemName: "line.3.horizontal")
                        .font(.title2)
                        .foregroundColor(.accentColor)
                }
                .sheet(isPresented: $showReorderSheet) {
                    ReorderProjectsView(projects: $projects)
                }

                Spacer()

                HStack(spacing: 10) {
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor(.yellow)
                        .font(.title3)
                    
                    Button(action: {
                        // Placeholder para abrir configuración
                    }) {
                        Image(systemName: "person.circle.fill")
                            .foregroundColor(.primary)
                            .font(.title)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 25)
            .padding(.top, 15)
            .padding(.bottom, 12)
            
            ProjectsBar(
                projects: projects,
                section: section,
                onTapNew: onTapNew
            )
        }
    }
}

#Preview {
    NavigationBarView(
        projects: .constant(SampleData.sampleProjects),
        section: .tasks,
        onTapNew: {}
    )
}
