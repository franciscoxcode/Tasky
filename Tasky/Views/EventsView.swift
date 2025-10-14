//
//  EventsView.swift
//  Tasky
//
//  Created by Francisco Jean on 02/10/25.
//

import SwiftUI

struct EventsView: View {
    @ObservedObject var viewModel: EventsViewModel
    let selectedProjectID: UUID?

    var body: some View {
        Group {
            if viewModel.filteredEvents.isEmpty {
                ContentUnavailableView(label: {
                    Label("No Events", systemImage: "calendar")
                }, description: {
                    Text("Try selecting a different project or create a new event.")
                })
            } else {
                List {
                    ForEach(viewModel.filteredEvents) { event in
                        VStack(alignment: .leading, spacing: 5) {
                            HStack(spacing: 8) {
                                Text(String(event.emoji))
                                    .font(.title3)
                                Text(event.title)
                                    .font(.headline)
                            }

                            Text(event.date, style: .date)
                                .font(.subheadline)
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
    EventsView(
        viewModel: EventsViewModel(events: SampleData.sampleEvents),
        selectedProjectID: nil
    )
}
