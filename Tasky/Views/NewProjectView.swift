import SwiftUI

struct NewProjectView: View {
    var onSave: (Project) -> Void
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

    var body: some View {
        VStack(spacing: 16) {
            Text("New Project")
                .font(.headline)
                .padding(.top, 8)
            

            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 60, height: 60)

                    Text(emojiText.isEmpty ? "📁" : emojiText)
                        .font(.largeTitle)
                }
                .onTapGesture {
                    isEmojiFieldFocused = true
                }
                .textFieldStyle(.plain)
                .overlay(
                    TextField("", text: $emojiText)
                        .opacity(0)
                )

                TextField("Project name", text: $name)
                    .textFieldStyle(.roundedBorder)
                ColorPicker("", selection: $color, supportsOpacity: false)
                    .labelsHidden()
            }


            VStack(alignment: .leading, spacing: 8) {
                Text("Show in:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                HStack(spacing: 10) {
                    SectionToggleButton(
                        title: "Events",
                        isOn: $showInEvents,
                        color: .mint
                    )

                    SectionToggleButton(
                        title: "Tasks",
                        isOn: $showInTasks,
                        color: .indigo.opacity(0.8)
                    )

                    SectionToggleButton(
                        title: "Notes",
                        isOn: $showInNotes,
                        color: .pink.opacity(0.6)
                    )
                }
            }

            HStack(spacing: 20) {
                Button("Cancel") {
                    onCancel()
                }
                .buttonStyle(.bordered)

                Button("Save") {
                    let emojiChar: Character? = emojiText.first
                    let project = Project(
                        emoji: emojiChar,
                        name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                        color: color,
                        visibleIn: visibleIn
                    )
                    onSave(project)
                }
                .buttonStyle(.borderedProminent)
                .disabled(isSaveDisabled)
            }
            .padding(.top, 14)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(20)
        .frame(width: 300)
        .background(Color.white.opacity(0.95))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 12)
    }
}

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
        onSave: { newProject in
            print("Preview created:", newProject)
        },
        onCancel: {
            print("Preview canceled")
        }
    )
}
