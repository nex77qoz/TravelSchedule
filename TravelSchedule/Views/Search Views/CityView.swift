import SwiftUI

struct CityView: View {
    @Binding var schedule: Schedule
    @Binding var navPath: [ViewsChanger]
    @Binding var direction: Int

    @State private var searchString = String()

    // Результаты поиска по названию города (если строка поиска не пуста)
    private var searchingResults: [City] {
        searchString.isEmpty
            ? schedule.cities
            : schedule.cities.filter { $0.title.lowercased().contains(searchString.lowercased()) }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Поисковая строка
            SearchBarView(searchText: $searchString)

            // Отображение, если ничего не найдено
            if searchingResults.isEmpty {
                EmptySearchView(notification: "Город не найден")
            } else {
                // Список результатов
                ScrollView(.vertical) {
                    ForEach(searchingResults) { city in
                        NavigationLink(value: ViewsChanger.stationView) {
                            SelectableRowView(title: city.title)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            // Запоминаем выбранный город
                            schedule.destinations[direction].cityTitle = city.title
                        })
                    }
                }
                .padding(.vertical, .spacerL)
            }

            Spacer()
        }
        .setCustomNavigationBar(title: "Выбор города")
        .foregroundStyle(.ypBlackDuo)
        .onAppear {
            // Очищаем поисковую строку при открытии
            searchString = String()
        }
    }
}

#Preview {
    NavigationStack {
        CityView(
            schedule: .constant(Schedule.sampleData),
            navPath: .constant([]),
            direction: .constant(0)
        )
    }
}
