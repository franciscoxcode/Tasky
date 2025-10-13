//
//  ReorderProjectsView.swift
//  Tasky
//
//  Created by Francisco Jean on 13/10/25.
//
import SwiftUI

struct ReorderProjectsView: View {
    let projects = SampleData.sampleProjects
    
    var body: some View {
        List {
            Section("Reorder Projects") {
                ForEach(projects) { project in
                    HStack(spacing: 15) {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(.accentColor)
                        Text(String(project.emoji))
                        Text(project.name)
                    }
                    .padding(3)
                    }
            }
        }
        .font(.system( size: 16))
    }
}

#Preview {
    ReorderProjectsView()
}
