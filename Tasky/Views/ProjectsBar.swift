import SwiftUI

struct ProjectsBar: View {
    let projects: [Project]
    let section: Project.SectionType
    var onTapNew: (() -> Void)? = nil
    var onEdit: ((Project) -> Void)? = nil   // 👈 nuevo

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 18) {

                // Botón "+" para nuevo proyecto
                Button {
                    onTapNew?()
                } label: {
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

                // Proyectos
                ForEach(
                    projects
                        .filter { $0.visibleIn.contains(section) }
                        .sorted { $0.order < $1.order }
                ) { project in
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
                    .onLongPressGesture {
                        onEdit?(project)     // 👈 dispara edición
                    }
                }
            }
            .padding(.horizontal, 25)
        }
    }
}

#Preview {
    ProjectsBar(
        projects: SampleData.sampleProjects,
        section: .tasks,
        onTapNew: {},
        onEdit: { _ in }
    )
}
