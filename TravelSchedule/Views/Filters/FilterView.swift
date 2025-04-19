import SwiftUI

struct FilterView: View {
    @Binding var viewModelFilter: Filter
    @State private var currentFilter = Filter()

    @Environment(\.dismiss) private var dismiss

    private enum Constants {
        static let timeSectionTitle       = "Время отправления"
        static let connectionSectionTitle = "Показывать варианты с пересадками"
        static let buttonTitle            = "Применить"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            timeSection
            connectionSection
            Spacer()
            if currentFilter != viewModelFilter {
                applyButton
            }
        }
        .setCustomNavigationBar()
        .onAppear(perform: loadFilter)
    }
}

private extension FilterView {
    var timeSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionTitle(Constants.timeSectionTitle)
            CheckboxView(type: .morning,  isOn: $currentFilter.isAtMorning)
            CheckboxView(type: .afternoon,isOn: $currentFilter.isAtAfternoon)
            CheckboxView(type: .evening,  isOn: $currentFilter.isAtEvening)
            CheckboxView(type: .night,    isOn: $currentFilter.isAtNight)
        }
    }

    var connectionSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionTitle(Constants.connectionSectionTitle)
            RadioButtonView(isOn: $currentFilter.isWithTransfers)
        }
    }

    var applyButton: some View {
        Button {
            saveFilter()
            dismiss()
        } label: {
            Text(Constants.buttonTitle)
                .setCustomButton(padding: .horizontal)
        }
    }

    func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.boldMedium)
            .padding(.L)
    }

    func loadFilter() {
        currentFilter = viewModelFilter
    }

    func saveFilter() {
        viewModelFilter = currentFilter
    }
}

#Preview {
    NavigationStack {
        FilterView(viewModelFilter: .constant(Filter.customSearch))
    }
}
