//
//  ProjectsBar.swift
//  Tasky
//
//  Created by Francisco Jean on 02/10/25.
//
import SwiftUI

struct ProjectsBar: View {
    let projects: [Project]
    let section: Project.SectionType
    var onTapNew: (() -> Void)? = nil
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 18) {
                Button(action: {
                    onTapNew?()
                }) {
                    VStack {
                        Text("+")
                            .font(.title)
                            .frame(width: 60, height: 60)
                            .background(Circle().fill(Color.gray.opacity(0.1)))
                            .foregroundColor(.primary)
                        
                        Text("New")
                            .font(.caption)
                            .lineLimit(1)
                            .frame(width: 55)
                            .truncationMode(.tail)
                            .foregroundColor(.primary)
                    }
                }
                
                ForEach(projects
                            .filter { $0.visibleIn.contains(section) }
                            .sorted { $0.order < $1.order }) { project in
                    VStack {
                        Text(String(project.emoji))
                            .font(.title)
                            .frame(width: 60, height: 60)
                            .background(Circle().fill(Color.gray.opacity(0.1)))
                        
                        Text(project.name)
                            .font(.caption)
                            .lineLimit(1)
                            .frame(width: 55)
                            .truncationMode(.tail)
                    }
                }
            }
            .padding(25)
        }
    }
}

#Preview {
    ProjectsBar(
        projects: SampleData.sampleProjects,
        section: .tasks
    )
}
