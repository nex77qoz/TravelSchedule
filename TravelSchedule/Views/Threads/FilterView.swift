import SwiftUI

struct FilterView: View {
    @Binding var filter: Filter
    @State var currentFilter = Filter()

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Блок: Время отправления
            Text("Время отправления")
                .font(.boldMedium)
                .padding(.spacerL)

            Group {
                CheckboxRowView(title: "Утро 06:00 - 12:00", isOn: $currentFilter.isMorning)
                CheckboxRowView(title: "День 12:00 - 18:00", isOn: $currentFilter.isAfternoon)
                CheckboxRowView(title: "Вечер 18:00 - 00:00", isOn: $currentFilter.isEvening)
                CheckboxRowView(title: "Ночь 00:00 - 06:00", isOn: $currentFilter.isAtNight)
            }

            // Блок: Пересадки
            Text("Показывать варианты с пересадками")
                .font(.boldMedium)
                .padding(.spacerL)

            VStack(spacing: 0) {
                RadioRowView(title: "Да", isOn: $currentFilter.isWithTransfers)
                RadioRowView(title: "Нет", isOn: $currentFilter.isWithTransfers.not)
            }

            Spacer()

            // Кнопка "Применить", если фильтр был изменён
            if currentFilter != filter {
                Button {
                    filter = currentFilter
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Применить")
                        .font(.boldSmall)
                }
                .frame(maxWidth: .infinity, maxHeight: 60)
                .background(.ypBlue)
                .foregroundStyle(.ypWhite)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, .spacerL)
            }
        }
        .setCustomNavigationBar()
        .onAppear {
            currentFilter = filter
        }
    }
}

#Preview {
    NavigationStack {
        FilterView(filter: .constant(Filter.fullSearch))
    }
}

// Удобный биндинг для инверсии булевых значений
extension Binding where Value == Bool {
    var not: Binding<Bool> {
        Binding<Bool>(
            get: { !self.wrappedValue },
            set: { self.wrappedValue = !$0 }
        )
    }
}
