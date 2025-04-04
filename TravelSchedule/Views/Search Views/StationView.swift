import SwiftUI

struct StationView: View {
    
    // MARK: - Свойства
    @Binding var schedule: Schedule
    @Binding var navPath: [ViewsChanger]
    @Binding var direction: Int

    @State private var searchString = String()

    
    // MARK: - Вычисляемые свойства
    private var searchingResults: [Station] {
        searchString.isEmpty
            ? schedule.stations
            : schedule.stations.filter { $0.title.lowercased().contains(searchString.lowercased()) }
    }

    
    // MARK: - Основное представление
    var body: some View {
        VStack(spacing: 0) {
            // Поисковая строка
            SearchBarView(searchText: $searchString)

            if searchingResults.isEmpty {
                // Отображение при отсутствии результатов
                EmptySearchView(notification: "Станция не найдена")
            } else {
                // Список найденных станций
                ScrollView {
                    ForEach(searchingResults) { station in
                        Button {
                            // Сохраняем выбранную станцию и возвращаемся назад
                            schedule.destinations[direction].stationTitle = station.title
                            navPath.removeAll()
                        } label: {
                            SelectableRowView(title: station.title)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
                .padding(.vertical, .spacerL)
            }

            Spacer()
        }
        .setCustomNavigationBar(title: "Выбор станции")
        .foregroundStyle(.ypBlackDuo)
        .onAppear {
            // Очищаем строку поиска при открытии экрана
            searchString = String()
        }
    }
}

#Preview {
    NavigationStack {
        StationView(
            schedule: .constant(Schedule.sampleData),
            navPath: .constant([]),
            direction: .constant(.departure)
        )
    }
}
