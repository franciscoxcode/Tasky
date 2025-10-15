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
            } else if selectedProjectID == nil {
                List {
                    ForEach(viewModel.groupedSections) { section in
                        Section(header:
                            Text(section.title)
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(.primary)
                                .padding(.bottom, 4)
                        ) {
                            ForEach(section.events) { event in
                                eventRow(for: event, includeDate: false)
                            }
                        }
                    }
                }
                .listStyle(.plain)
            } else {
                List(viewModel.filteredEvents) { event in
                    eventRow(for: event, includeDate: true)
                }
                .listStyle(.plain)
            }
        }
    }

    @ViewBuilder
    private func eventRow(for event: Event, includeDate: Bool) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Text(String(event.emoji))
                    .font(.body)

                Text(event.title)
                    .font(.body)
                    .foregroundColor(.primary)
                    .opacity(0.7)
            }

            if includeDate {
                Text(event.date, format: .dateTime.day().month().year())
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }

            let detail = viewModel.detailText(for: event)
            Text(detail)
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    EventsView(
        viewModel: EventsViewModel(events: SampleData.sampleEvents),
        selectedProjectID: nil
    )
}
