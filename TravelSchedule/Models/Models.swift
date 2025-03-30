import Foundation

// MARK: - Модели для работы с расписанием путешествий

// MARK: - Перевозчики

/// Перевозчик 
struct Carrier: Hashable, Identifiable {
    let id = UUID()
    let title: String
    let logoName: String
    let email: String
    let phone: String
}

// Примеры перевозчиков для тестирования
extension Carrier {
    static let sampleData: [Carrier] = [
        Carrier(title: "РЖД", logoName: "rzhd", email: "i.lozgkina@yandex.ru", phone: "+7 (904) 329-27-71"),
        Carrier(title: "ФГК", logoName: "fgk", email: "i.lozgkina@yandex.ru", phone: "+7 (904) 329-27-71"),
        Carrier(title: "Урал логистика", logoName: "ural", email: "i.lozgkina@yandex.ru", phone: "+7 (904) 329-27-71")
    ]
}

// MARK: - Локации

/// Город
struct City: Hashable, Identifiable {
    let id = UUID()
    let title: String       // Название города
}

// Примеры городов для тестирования
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

/// Станция (вокзал)
struct Station: Hashable, Identifiable {
    let id = UUID()
    let title: String       // Название станции
}

// Примеры станций для тестирования
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

/// Пункт назначения (город + станция)
struct Destination: Hashable, Identifiable {
    let id = UUID()
    var cityTitle: String = ""
    var stationTitle: String = ""
}

// Примеры пунктов назначения
extension Destination {
    /// Пустые пункты назначения для инициализации
    static var emptyDestination = [Destination(), Destination()]

    /// Примеры пунктов назначения для тестирования
    static let sampleData: [Destination] = [
        Destination(cityTitle: "Москва", stationTitle: "Ярославский Вокзал"),
        Destination(cityTitle: "Санкт-Петербург", stationTitle: "Балтийский вокзал")
    ]
}

// MARK: - Маршруты и расписания

/// Фильтр поиска маршрутов
struct Filter: Hashable {
    var isWithTransfers = true
    var isAtNight = true
    var isMorning = true
    var isAfternoon = true
    var isEvening = true
}

// Стандартный фильтр для полного поиска
extension Filter {
    static let fullSearch = Filter()
}

/// Маршрут
struct Route: Hashable, Identifiable {
    let id = UUID()
    let date: String
    let departureTime: String
    let arrivalTime: String
    let durationTime: String
    let connectionStation: String
    
    /// Является ли маршрут прямым (без пересадок)
    var isDirect: Bool {
        connectionStation.isEmpty
    }
    
    let carrierID: UUID        // Идентификатор перевозчика
}

// Примеры маршрутов для тестирования
extension Route {
    static let sampleData: [Route] = [
        Route(
            date: "14 января",
            departureTime: "22:30",
            arrivalTime: "08:15",
            durationTime: "20",
            connectionStation: "Костроме",
            carrierID: Carrier.sampleData[0].id
        ),
        Route(
            date: "15 января",
            departureTime: "01:15",
            arrivalTime: "09:00",
            durationTime: "9",
            connectionStation: "",
            carrierID: Carrier.sampleData[1].id
        ),
        Route(
            date: "16 января",
            departureTime: "12:30",
            arrivalTime: "21:00",
            durationTime: "9",
            connectionStation: "",
            carrierID: Carrier.sampleData[2].id
        ),
        Route(
            date: "17 января",
            departureTime: "22:30",
            arrivalTime: "08:15",
            durationTime: "20",
            connectionStation: "Костроме",
            carrierID: Carrier.sampleData[0].id
        ),
        Route(
            date: "17 января",
            departureTime: "18:00",
            arrivalTime: "01:00",
            durationTime: "7",
            connectionStation: "",
            carrierID: Carrier.sampleData[0].id
        )
    ]
}

/// Основная модель расписания
struct Schedule: Hashable, Identifiable {
    let id = UUID()
    let cities: [City]
    let stations: [Station]
    var destinations: [Destination]
    let routes: [Route]
    let carriers: [Carrier]
}

// Пример расписания для тестирования
extension Schedule {
    static let sampleData = Schedule(
        cities: City.sampleData,
        stations: Station.sampleData,
        destinations: Destination.emptyDestination,
        routes: Route.sampleData,
        carriers: Carrier.sampleData
    )
}

// MARK: - Истории и контент

/// История
struct Story: Hashable, Identifiable {
    let id = UUID()
    let previewImageName: String
    let pageImageNames: [String]
    let title: String
    let text: String
    var isRead: Bool
}

// Примеры историй для тестирования
extension Story {
    static let sampleData = [
        Story(
            previewImageName: "preview1",
            pageImageNames: ["big1-1", "big1-2"],
            title: "Text Text",
            text: "Text Text Text Text Text Text Text Text",
            isRead: false
        ),
        Story(
            previewImageName: "preview2",
            pageImageNames: ["big2-1", "big2-2"],
            title: "Text Text",
            text: "Text Text Text Text Text Text Text Text",
            isRead: false
        ),
        Story(
            previewImageName: "preview3",
            pageImageNames: ["big1-1", "big1-2"],
            title: "Text Text",
            text: "Text Text Text Text Text Text Text Text",
            isRead: false
        ),
        Story(
            previewImageName: "preview4",
            pageImageNames: ["big2-1", "big2-2"],
            title: "Text Text",
            text: "Text Text Text Text Text Text Text Text",
            isRead: false
        ),
        Story(
            previewImageName: "preview5",
            pageImageNames: ["big1-1", "big1-2"],
            title: "Text Text",
            text: "Text Text Text Text Text Text Text Text",
            isRead: false
        ),
        Story(
            previewImageName: "preview6",
            pageImageNames: ["big2-1", "big2-2"],
            title: "Text Text",
            text: "Text Text Text Text Text Text Text Text",
            isRead: false
        ),
        Story(
            previewImageName: "preview7",
            pageImageNames: ["big1-1", "big1-2"],
            title: "Text Text",
            text: "Text Text Text Text Text Text Text Text",
            isRead: false
        ),
        Story(
            previewImageName: "preview8",
            pageImageNames: ["big2-1", "big2-2"],
            title: "Text Text",
            text: "Text Text Text Text Text Text Text Text",
            isRead: false
        ),
        Story(
            previewImageName: "preview9",
            pageImageNames: ["big1-1", "big1-2"],
            title: "Text Text",
            text: "Text Text Text Text Text Text Text Text",
            isRead: false
        )
    ]
}
