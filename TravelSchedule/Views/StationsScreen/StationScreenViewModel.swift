import SwiftUI

@MainActor
final class StationScreenViewModel: ObservableObject {
    enum State: Equatable {
        case loading
        case loaded
    }

    let title = "Выбор станции"
    let notification = "Станция не найдена"

    @Published var searchString = ""
    @Published private(set) var state: State = .loading

    var filteredStations: [Station] {
        if searchString.isEmpty {
            return stations
        }
        return stations.filter {
            $0.title.localizedCaseInsensitiveContains(searchString)
        }
    }

    private let store: [Components.Schemas.Settlements]
    private let city: City
    private var stations: [Station]

    init(
        store: [Components.Schemas.Settlements],
        city: City,
        stations: [Station] = []
    ) {
        self.store = store
        self.city = city
        self.stations = stations
    }

    func fetchStations() {
        Task { [store, city] in
            state = .loading
            let converted = store
                .filter { $0.codes?.yandex_code == city.yandexCode }
                .flatMap { $0.stations ?? [] }
                .compactMap(convert)
            stations = sortStationsByType(converted)
            state = .loaded
        }
    }
}

private extension StationScreenViewModel {
    func sortStationsByType(_ list: [Station]) -> [Station] {
        let sorted = list.sorted { $0.title < $1.title }
        let priority = ["airport", "train_station", "marine_station", "river_port", "bus_station"]
        var result: [Station] = []
        for type in priority {
            result += sorted.filter { $0.type == type }
        }
        let rest = sorted.filter { !priority.contains($0.type) }
        return result + rest
    }

    func convert(from item: Components.Schemas.SettlementsStations) -> Station? {
        guard
            let rawType = item.station_type,
            let rawTitle = item.title,
            let code = item.codes?.yandex_code,
            let latPayload = item.latitude,
            let lonPayload = item.longitude,
            let latitude = extract(latPayload),
            let longitude = extract(lonPayload),
            latitude != 0,
            longitude != 0
        else { return nil }

        let title = rawType == "airport"
            ? "Аэропорт \(rawTitle)"
            : rawTitle
        return Station(
            title: title,
            type: rawType,
            code: code,
            latitude: latitude,
            longitude: longitude
        )
    }

    func extract(_ payload: Components.Schemas.SettlementsStations.latitudePayload) -> Double? {
        switch payload {
        case .case1(let value): return value
        case .case2: return nil
        }
    }

    func extract(_ payload: Components.Schemas.SettlementsStations.longitudePayload) -> Double? {
        switch payload {
        case .case1(let value): return value
        case .case2: return nil
        }
    }
}
