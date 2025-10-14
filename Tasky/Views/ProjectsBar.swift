import SwiftUI

struct ProjectsBar: View {
    let projects: [Project]
    let section: Project.SectionType
    @Binding var selectedProjectID: UUID?
    var onTapNew: (() -> Void)? = nil
    var onEdit: ((Project) -> Void)? = nil

    private var visibleProjects: [Project] {
        projects
            .filter { $0.visibleIn.contains(section) }
            .sorted { $0.order < $1.order }
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 18) {
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
                .buttonStyle(.plain)

                projectSelectionButton(
                    title: "All",
                    iconText: "📦",
                    isSelected: selectedProjectID == nil
                ) {
                    selectedProjectID = nil
                }

                ForEach(visibleProjects) { project in
                    projectSelectionButton(
                        title: project.name,
                        iconText: String(project.emoji),
                        isSelected: selectedProjectID == project.id
                    ) {
                        selectedProjectID = project.id
                    } onLongPress: {
                        selectedProjectID = project.id
                        onEdit?(project)
                    }
                }
            }
            .padding(.horizontal, 25)
        }
    }

    @ViewBuilder
    private func projectSelectionButton(
        title: String,
        iconText: String,
        isSelected: Bool,
        onTap: @escaping () -> Void,
        onLongPress: (() -> Void)? = nil
    ) -> some View {
        ProjectButtonContent(
            title: title,
            iconText: iconText,
            isSelected: isSelected
        )
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
        .highPriorityGesture(
            LongPressGesture(minimumDuration: 0.45)
                .onEnded { _ in onLongPress?() }
        )
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
