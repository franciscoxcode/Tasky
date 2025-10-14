import SwiftUI

struct NotesView: View {
    @ObservedObject var viewModel: NotesViewModel

    var body: some View {
        Group {
            if viewModel.filteredNotes.isEmpty {
                ContentUnavailableView(label: {
                    Label("No Notes", systemImage: "note.text")
                }, description: {
                    Text("Try selecting a different project or create a new note.")
                })
            } else {
                List(viewModel.filteredNotes) { note in
                    VStack(alignment: .leading, spacing: 4) {
                        if let title = note.title, !title.isEmpty {
                            Text(title)
                                .font(.headline)
                        }

                        Text(note.content)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

#Preview {
    NotesView(viewModel: NotesViewModel(notes: SampleData.sampleNotes))
}
