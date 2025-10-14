//
//  ReorderProjectsView.swift
//  Tasky
//
//  Created by Francisco Jean on 13/10/25.
//

import SwiftUI

struct ReorderProjectsView: View {
    @Binding var projects: [Project]
    @State private var editMode: EditMode = .active
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section("Reorder Projects") {
                        ForEach(projects) { project in
                            HStack(spacing: 15) {
                                Text(String(project.emoji))
                                Text(project.name)
                            }
                            .padding(3)
                        }
                        .onMove { indices, newOffset in
                            projects.move(fromOffsets: indices, toOffset: newOffset)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color(.secondarySystemBackground))
            }
            .environment(\.editMode, $editMode)
            .toolbar {
                Button("Done") {
                    editMode = .inactive
                    dismiss()
                }
                .bold()
            }
        }
        .background(Color.black.opacity(0.3).ignoresSafeArea())
    }
}

#Preview {
    ReorderProjectsView(projects: .constant(SampleData.sampleProjects))
}
