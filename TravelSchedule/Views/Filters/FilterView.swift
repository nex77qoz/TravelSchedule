import SwiftUI

struct FilterView: View {
    private let timeSectionTitle = "Время отправления"
    private let connectionSectionTitle = "Показывать варианты с пересадками"
    private let buttonTitle = "Применить"

    @Binding var viewModelFilter: Filter
    @State var currentFilter = Filter()

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            timeSectionView
            connectionSectionView
            Spacer()
            if currentFilter != viewModelFilter {
                buttonView
            }
        }
        .setCustomNavigationBar()
        .onAppear {
            loadFilter()
        }
    }
}

private extension FilterView {
    var timeSectionView: some View {
        VStack(alignment: .leading, spacing: .zero) {
            show(title: timeSectionTitle)
            CheckboxView(type: .morning, isOn: $currentFilter.isAtMorning)
            CheckboxView(type: .afternoon, isOn: $currentFilter.isAtAfternoon)
            CheckboxView(type: .evening, isOn: $currentFilter.isAtEvening)
            CheckboxView(type: .night, isOn: $currentFilter.isAtNight)
        }
    }

    var connectionSectionView: some View {
        VStack(alignment: .leading, spacing: .zero) {
            show(title: connectionSectionTitle)
            RadioButtonView(isOn: $currentFilter.isWithTransfers)
        }
    }

    var buttonView: some View {
        Button {
            saveFilter()
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Text(buttonTitle)
                .setCustomButton(padding: .horizontal)
        }
    }
}

private extension FilterView {
    func show(title: String) -> some View {
        Text(title)
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
