import SwiftUI

struct NotesView: View {
    @ObservedObject var viewModel: NotesViewModel
    let selectedProjectID: UUID?

    var body: some View {
        Group {
            if viewModel.filteredNotes.isEmpty {
                ContentUnavailableView(label: {
                    Label("No Notes", systemImage: "note.text")
                }, description: {
                    Text("Try selecting a different project or create a new note.")
                })
            } else {
                List {
                    ForEach(viewModel.filteredNotes) { note in
                        VStack(alignment: .leading, spacing: 4) {
                            if let title = note.title, !title.isEmpty {
                                Text(title)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                    .opacity(0.7)
                            }

                            Text(note.content)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onMove { indices, newOffset in
                        viewModel.move(from: indices, to: newOffset, selectedProjectID: selectedProjectID)
                    }
                }
                .listStyle(.plain)
                .environment(\.editMode, .constant(.active))
            }
        }
    }
}

#Preview {
    NotesView(
        viewModel: NotesViewModel(notes: SampleData.sampleNotes),
        selectedProjectID: nil
    )
}
