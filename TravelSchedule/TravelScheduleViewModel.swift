import SwiftUI
import UIKit

@MainActor
class TravelScheduleViewModel: ObservableObject {
    private let api = YandexScheduleAPI(apiKey: "0644a1c7-41cd-46e3-98cc-e2607268dea6")
    
    private var lastThreadUid: String?
    private var lastSearchThreadUid: String?
    private var lastCarrierCode: Int?
    
    @Published var testResults: [TestResult] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    func runTests() {
        testResults = []
        isLoading = true
        addResult(title: "Запуск тестов", status: "🚀", details: "Инициализация соединения с API...")
        Task {
            await self.runAllTests()
        }
    }
    
    private func runAllTests() async {
        do {
            try await validateAPIKey()
            try await testStationSearch()
            try await testNearestCity()
            try await testNearestTrainStation()
            try await testStationSchedule()
            try await testRouteSearch()
            try await testThreadInfo()
            try await testSpecificCarrier()
            try await testCopyright()
            addResult(title: "Тестирование завершено", status: "🎉", details: "Все тесты API завершены")
        } catch {
            addResult(title: "Ошибка", status: "❌", details: "\(error.localizedDescription)")
            errorMessage = "\(error.localizedDescription)"
        }
        isLoading = false
    }
    
    private func validateAPIKey() async throws {
        addResult(title: "Проверка API-ключа", status: "⏱️", details: "Проверка API-ключа...")
        let isValid = await api.validateAPIKey()
        if isValid {
            updateLastResult(status: "✅", details: "API-ключ действителен")
        } else {
            updateLastResult(status: "❌", details: "Неверный API-ключ")
            throw TravelScheduleError.unauthorized
        }
    }
    
    private func testStationSearch() async throws {
        addResult(title: "Поиск станций", status: "⏱️", details: "Поиск станций в Москве...")
        let response = try await api.stationsService.searchStations(query: "Москва")
        let stationCount = countStations(in: response)
        updateLastResult(status: "✅", details: "Найдено \(stationCount) станций")
    }
    
    private func countStations(in response: StationsResponse) -> Int {
        var count = 0
        if let countries = response.countries {
            for country in countries {
                for region in country.regions {
                    for settlement in region.settlements {
                        count += settlement.stations.count
                    }
                }
            }
        }
        return count
    }
    
    private func testNearestCity() async throws {
        addResult(title: "Ближайший город", status: "⏱️", details: "Поиск ближайшего города...")
        let city = try await api.settlementService.getNearestCity(lat: 50.440046, lng: 40.4882367, distance: 50)
        updateLastResult(status: "✅", details: "Ближайший город: \(city.title)")
    }
    
    private func testNearestTrainStation() async throws {
        addResult(title: "Ближайшие станции", status: "⏱️", details: "Поиск ближайшей станции типа train_station...")
        let response = try await api.stationsService.getNearestStations(lat: 55.75, lng: 37.62, distance: 5, transportTypes: ["train"])
        if let trainStation = response.stations.first(where: { $0.stationType == "train_station" }) {
            updateLastResult(status: "✅", details: "Первая станция с типом train_station: \(trainStation.title)")
        } else {
            updateLastResult(status: "❌", details: "Станция с типом train_station не найдена")
        }
    }
    
    private func testStationSchedule() async throws {
        addResult(title: "Расписание станции", status: "⏱️", details: "Получение расписания для Ленинградского вокзала...")
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        let tomorrowString = DateFormatter.apiDateFormatter.string(from: tomorrow)
        let schedule = try await api.scheduleService.getStationSchedule(station: "s2000005", date: tomorrowString, transportTypes: ["train"])
        updateLastResult(status: "✅", details: "Найдено \(schedule.schedule.count) поездов для \(schedule.station.title)")
        if let firstTrain = schedule.schedule.first {
            lastThreadUid = firstTrain.thread.uid
        }
    }
    
    private func testRouteSearch() async throws {
        addResult(title: "Поиск маршрута", status: "⏱️", details: "Поиск маршрутов из Москвы в Санкт-Петербург...")
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        let tomorrowString = DateFormatter.apiDateFormatter.string(from: tomorrow)
        let routes = try await api.routesService.searchRoutes(from: "c213", to: "c2", date: tomorrowString, transportTypes: ["train"])
        updateLastResult(status: "✅", details: "Найдено \(routes.segments.count) маршрутов из \(routes.search.from.title) в \(routes.search.to.title)")
        if let firstSegment = routes.segments.first {
            lastSearchThreadUid = firstSegment.thread.uid
            addResult(title: "UID маршрута", status: "ℹ️", details: "UID первого thread: \(firstSegment.thread.uid)")
            lastThreadUid = firstSegment.thread.uid
        }
    }
    
    private func testThreadInfo() async throws {
        guard let uid = lastThreadUid else {
            addResult(title: "Информация о нитке", status: "❌", details: "Не удалось получить uid нитки")
            return
        }
        addResult(title: "Информация о нитке", status: "⏱️", details: "Получен uid нитки: \(uid). Запрос информации о нитке...")
        let threadResponse = try await api.threadService.getThreadInfo(uid: uid)
        updateLastResult(status: "✅", details: "Поезд \(threadResponse.thread.title) имеет \(threadResponse.stops.count) остановок. JSON файл получен.")
        lastCarrierCode = threadResponse.thread.carrier.code
    }
    
    private func testSpecificCarrier() async throws {
        guard let carrierCode = lastCarrierCode else {
            addResult(title: "Конкретный перевозчик", status: "❌", details: "Код перевозчика не получен из запроса.")
            return
        }
        addResult(title: "Конкретный перевозчик", status: "⏱️", details: "Получение данных для перевозчика с кодом \(carrierCode)...")
        let carrier = try await api.carrierService.getCarrierById(code: carrierCode)
        updateLastResult(status: "✅", details: "Получен перевозчик: \(carrier.title)")
    }
    
    private func testCopyright() async throws {
        addResult(title: "Копирайт Яндекс Расписаний", status: "⏱️", details: "Получение данных копирайта...")
        let copyrightResponse = try await api.copyrightService.getCopyright()
        let text = copyrightResponse.copyright.text ?? "нет текста"
        updateLastResult(status: "✅", details: "Копирайт получен: \(text)")
    }
    
    private func addResult(title: String, status: String, details: String) {
        testResults.append(TestResult(title: title, status: status, details: details))
    }
    
    private func updateLastResult(status: String, details: String) {
        if let lastIndex = testResults.indices.last {
            let lastResult = testResults[lastIndex]
            testResults[lastIndex] = TestResult(title: lastResult.title, status: status, details: details)
        }
    }
}
