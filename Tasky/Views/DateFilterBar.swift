import SwiftUI

struct DateFilterBar: View {
    let selectedFilter: DateFilterOption
    let onSelect: (DateFilterOption) -> Void
    let onPickDate: () -> Void

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(DateFilterOption.presets, id: \.self) { option in
                    Button {
                        onSelect(option)
                    } label: {
                        filterLabel(for: option, isSelected: selectedFilter == option)
                    }
                    .buttonStyle(.plain)
                }

                Button {
                    onPickDate()
                } label: {
                    filterLabel(forPickDate: selectedFilter)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 28)
            
        }
    }

    private func filterLabel(for option: DateFilterOption, isSelected: Bool) -> some View {
        Text(label(for: option))
            .font(.footnote)
            .underline(isSelected ? true : false)
            .foregroundStyle(isSelected ? Color.accentColor : Color.secondary)
    }

    private func filterLabel(forPickDate filter: DateFilterOption) -> some View {
        let isSpecific = filter.isSpecificSelection
        let text: String

        if case let .specific(date) = filter {
            text = Self.dateFormatter.string(from: date)
        } else {
            text = "Pick Date"
        }

        return Text(text)
            .font(.footnote)
            .fontWeight(isSpecific ? .semibold : .regular)
            .foregroundStyle(isSpecific ? Color.primary : Color.secondary)
    }

    private func label(for option: DateFilterOption) -> String {
        switch option {
        case .anyDate:
            return "Any"
        case .today:
            return "Today"
        case .tomorrow:
            return "Tomorrow"
        case .weekend:
            return "Weekend"
        case .nextWeek:
            return "Next Week"
        case .specific:
            return "Pick Date"
        }
    }
}

struct DateFilterBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            DateFilterBar(selectedFilter: .anyDate, onSelect: { _ in }, onPickDate: {})
            DateFilterBar(selectedFilter: .specific(Date()), onSelect: { _ in }, onPickDate: {})
        }
    }
}
