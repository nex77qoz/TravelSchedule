import SwiftUI

@MainActor
final class CityViewViewModel: ObservableObject {
    enum State: Equatable {
        case loading, loaded
    }

    enum Constants {
        static let title        = "Выбор города"
        static let notification = "Город не найден"
    }

    @Published var searchString = ""
    @Published private(set) var state: State = .loading

    var filteredCities: [City] {
        if searchString.isEmpty {
            return cities
        }
        return cities.filter {
            $0.title.localizedCaseInsensitiveContains(searchString)
        }
    }

    private var cities: [City]
    private let store: [Components.Schemas.Settlements]

    init(
        store: [Components.Schemas.Settlements],
        cities: [City] = []
    ) {
        self.store = store
        self.cities = cities
    }
}

extension CityViewViewModel {
    func fetchCities() {
        Task { [store] in
            state = .loading
            let converted = store.compactMap { settlement -> City? in
                guard
                    let title       = settlement.title,
                    let yandexCode  = settlement.codes?.yandex_code,
                    let count       = settlement.stations?.count
                else { return nil }

                return City(
                    title: title,
                    yandexCode: yandexCode,
                    stationsCount: count
                )
            }
            cities = converted.sorted { $0.stationsCount > $1.stationsCount }
            state  = .loaded
        }
    }
}
