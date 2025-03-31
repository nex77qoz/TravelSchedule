import Foundation

// MARK: - Локации

struct City: Hashable, Identifiable {
    let id = UUID()
    let title: String
}

extension City {
    static let sampleData = [
        City(title: "Москва"),
        City(title: "Санкт-Петербург"),
        City(title: "Сочи"),
        City(title: "Горный Воздух"),
        City(title: "Краснодар"),
        City(title: "Казань"),
        City(title: "Омск")
    ]
}

struct Station: Hashable, Identifiable {
    let id = UUID()
    let title: String
}

extension Station {
    static let sampleData = [
        Station(title: "Киевский вокзал"),
        Station(title: "Курский вокзал"),
        Station(title: "Ярославский вокзал"),
        Station(title: "Белорусский вокзал"),
        Station(title: "Савеловский вокзал"),
        Station(title: "Ленинградский вокзал")
    ]
}

struct Destination: Hashable, Identifiable {
    let id = UUID()
    var cityTitle: String = ""
    var stationTitle: String = ""
}

extension Destination {
    static var emptyDestination = [Destination(), Destination()]

    static let sampleData: [Destination] = [
        Destination(cityTitle: "Москва", stationTitle: "Ярославский Вокзал"),
        Destination(cityTitle: "Санкт-Петербург", stationTitle: "Балтийский вокзал")
    ]
}
