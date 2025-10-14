import SwiftUI

struct ProjectsBar: View {
    let projects: [Project]
    let section: Project.SectionType
    @Binding var selectedProjectID: UUID?
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
                            .frame(width: 64, height: 64)
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

                ProjectButtonContent(
                    title: "All",
                    iconText: "All",
                    isSelected: selectedProjectID == nil
                )
                .onTapGesture {
                    selectedProjectID = nil
                }
                Button {
                    selectedProjectID = nil
                } label: {
                    ProjectButtonContent(
                        title: "All",
                        iconText: "📦",
                        isSelected: selectedProjectID == nil
                    )
                }
                .buttonStyle(.plain)

                // Proyectos
                ForEach(
                    projects
                        .filter { $0.visibleIn.contains(section) }
                        .sorted { $0.order < $1.order }
                ) { project in
                    ProjectButtonContent(
                        title: project.name,
                        iconText: String(project.emoji),
                        isSelected: selectedProjectID == project.id
                    )
                    .onTapGesture {
                        selectedProjectID = project.id
                    Button {
                        selectedProjectID = project.id
                    } label: {
                        ProjectButtonContent(
                            title: project.name,
                            iconText: String(project.emoji),
                            isSelected: selectedProjectID == project.id
                        )
                    }
                    .buttonStyle(.plain)
                    .onLongPressGesture {
                        onEdit?(project)     // 👈 dispara edición
                    }
                }
            }
            .padding(.horizontal, 25)
        }
    }
}

private struct ProjectButtonContent: View {
    let title: String
    let iconText: String
    let isSelected: Bool

    var body: some View {
        VStack {
            Text(iconText)
                .font(.title)
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(isSelected ? Color.accentColor.opacity(0.2) : Color.gray.opacity(0.1))
                        .overlay(
                            Circle()
                                .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 2)
                        )
                )

            Text(title)
                .font(.caption)
                .lineLimit(1)
                .frame(width: 55)
                .truncationMode(.tail)
                .foregroundColor(.primary)
        }
        .foregroundColor(.primary)
    }
}

#Preview {
    ProjectsBar(
        projects: SampleData.sampleProjects,
        section: .tasks,
        selectedProjectID: .constant(nil),
        onTapNew: {},
        onEdit: { _ in }
    )
}
