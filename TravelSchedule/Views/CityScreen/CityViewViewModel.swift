import SwiftUI

@MainActor
final class CityViewViewModel: ObservableObject {
    enum State: Equatable {
        case loading, loaded
    }
    let title = "Выбор города"
    let notification = "Город не найден"

    @Published var searchString = String()
    @Published private(set) var state: State = .loading

    var filteredCities: [City] {
        searchString.isEmpty
            ? cities
            : cities.filter { $0.title.lowercased().contains(searchString.lowercased()) }
    }

    private var cities: [City]
    private var store: [Components.Schemas.Settlements]

    init(
        store: [Components.Schemas.Settlements],
        cities: [City] = []
    ) {
        self.store = store
        self.cities = cities
    }

    func fetchCities() {
        Task {
            state = .loading
            let convertedCities = store.compactMap { settlement -> City? in
                guard
                    let title = settlement.title,
                    let settlementCodes = settlement.codes,
                    let yandexCode = settlementCodes.yandex_code,
                    let settlementStations = settlement.stations
                else { return nil }

                return City(
                    title: title,
                    yandexCode: yandexCode,
                    stationsCount: settlementStations.count
                )
            }
            cities = convertedCities.sorted { $0.stationsCount > $1.stationsCount }
            state = .loaded
        }
    }
}
