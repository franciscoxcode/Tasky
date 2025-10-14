import SwiftUI

struct NewProjectView: View {
    var existingProject: Project? = nil
    var onSave: (Project) -> Void
    var onDelete: (() -> Void)? = nil
    var onCancel: () -> Void

    @State private var name = ""
    @State private var emojiText = ""
    @State private var color: Color = .blue
    @State private var showInEvents = true
    @State private var showInTasks = true
    @State private var showInNotes = true

    private var visibleIn: Set<Project.SectionType> {
        var set: Set<Project.SectionType> = []
        if showInEvents { set.insert(.events) }
        if showInTasks  { set.insert(.tasks)  }
        if showInNotes  { set.insert(.notes)  }
        return set
    }

    private var isSaveDisabled: Bool {
        name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    @FocusState private var isEmojiFieldFocused: Bool
    @FocusState private var isNameFieldFocused: Bool

    private var isEditing: Bool {
        existingProject != nil
    }

    var body: some View {
        VStack(spacing: 16) {
            // MARK: - Header
            Text(isEditing ? "Edit Project" : "New Project")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 8)

            // MARK: - Emoji + Name + Color
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(color.opacity(isEmojiFieldFocused ? 0.35 : 0.2))
                        .overlay(
                            Circle()
                                .stroke(isEmojiFieldFocused ? Color.accentColor : .clear, lineWidth: 3)
                        )
                        .frame(width: 60, height: 60)
                        .animation(.easeInOut(duration: 0.2), value: isEmojiFieldFocused)

                    Text(emojiText.isEmpty ? "📁" : emojiText)
                        .font(.largeTitle)
                }
                .onTapGesture {
                    isEmojiFieldFocused = true
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
                .overlay(
                    TextField("", text: $emojiText)
                        .frame(width: 1, height: 1)
                        .opacity(0.02)
                        .focused($isEmojiFieldFocused)
                        .keyboardType(.default)
                        .submitLabel(.done)
                        .onChange(of: emojiText) { oldValue, newValue in
                            if newValue.count > 1 {
                                emojiText = String(newValue.last!)
                            }
                        }
                )

                TextField("Project name", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .focused($isNameFieldFocused)

                ColorPicker("", selection: $color, supportsOpacity: false)
                    .labelsHidden()
            }

            // MARK: - Show In
            VStack(alignment: .leading, spacing: 8) {
                Text("Show in:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                HStack(spacing: 10) {
                    SectionToggleButton(title: "Events", isOn: $showInEvents, color: .mint)
                    SectionToggleButton(title: "Tasks",  isOn: $showInTasks,  color: .indigo.opacity(0.8))
                    SectionToggleButton(title: "Notes",  isOn: $showInNotes,  color: .pink.opacity(0.6))
                }
            }

            // MARK: - Buttons Row
            HStack {
                // DELETE on the left
                if isEditing, let onDelete {
                    Button(role: .destructive) {
                        onDelete()
                    } label: {
                        Text("Delete")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .buttonStyle(.plain)
                    .layoutPriority(1)
                    .foregroundColor(.red)
                }
                
                // CANCEL + UPDATE on the right
                HStack(spacing: 16) {
                    Button("Cancel") {
                        onCancel()
                    }

                    Button(isEditing ? "Update" : "Save") {
                        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
                        let emojiChar: Character? = emojiText.first
                        let project = Project(
                            id: existingProject?.id ?? UUID(),
                            emoji: emojiChar,
                            name: trimmedName,
                            color: color,
                            visibleIn: visibleIn,
                            order: existingProject?.order ?? 0
                        )
                        onSave(project)
                    }
                    .disabled(isSaveDisabled)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .layoutPriority(1) // 👈 asegura que los textos mantengan su espacio
            }
            .padding(.top, 14)
        }
        .padding(20)
        .frame(width: 300)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 12)
        .onAppear {
            if let existingProject {
                name = existingProject.name
                emojiText = String(existingProject.emoji)
                color = existingProject.color
                showInEvents = existingProject.visibleIn.contains(.events)
                showInTasks  = existingProject.visibleIn.contains(.tasks)
                showInNotes  = existingProject.visibleIn.contains(.notes)
            }

            DispatchQueue.main.async {
                isNameFieldFocused = true
            }
        }
    }
}

// MARK: - Toggle Button
private struct SectionToggleButton: View {
    let title: String
    @Binding var isOn: Bool
    var color: Color

    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            HStack(spacing: 6) {
                Image(systemName: isOn ? "circle.fill" : "circle")
                    .foregroundColor(isOn ? color : .gray)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(Color.gray.opacity(0.1))
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NewProjectView(
        existingProject: SampleData.sampleProjects.first,
        onSave: { _ in },
        onDelete: {},
        onCancel: {}
    )
}
