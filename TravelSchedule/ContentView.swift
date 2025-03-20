import SwiftUI
import UIKit

struct ContentView: View {
    @StateObject private var viewModel = TravelScheduleViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(viewModel.testResults, id: \.id) { result in
                            HStack(alignment: .top) {
                                Text(result.status)
                                    .font(.system(size: 24))
                                    .padding(.trailing, 5)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(result.title)
                                        .font(.headline)
                                    
                                    if !result.details.isEmpty {
                                        Text(result.details)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .padding(.vertical, 5)
                            .contextMenu { // Добавляем контекстное меню для копирования
                                Button(action: {
                                    let fullText = "\(result.status) \(result.title)\n\(result.details)"
                                    UIPasteboard.general.string = fullText
                                }) {
                                    Label("Копировать результат", systemImage: "doc.on.doc")
                                }
                            }
                            
                            Divider()
                        }
                        
                        if viewModel.isLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .padding()
                                Spacer()
                            }
                        }
                    }
                    .padding()
                }
                
                Button(action: {
                    viewModel.runTests()
                }) {
                    HStack {
                        Image(systemName: "network")
                        Text("Запустить тесты API")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.isLoading ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(viewModel.isLoading)
                .padding()
            }
            .navigationTitle("Тесты API расписания Яндекса")
        }
    }
}

struct TestResult: Identifiable {
    let id = UUID()
    let title: String
    let status: String // "✅", "❌", "⏱️", "ℹ️"
    let details: String
}

class TravelScheduleViewModel: ObservableObject {
    private let api = YandexScheduleAPI(apiKey: "0644a1c7-41cd-46e3-98cc-e2607268dea6")
    
    // Переменные для сохранения данных между запросами
    private var lastThreadUid: String?
    private var lastSearchThreadUid: String?
    private var lastCarrierCode: Int?

    @Published var testResults: [TestResult] = []
    @Published var isLoading: Bool = false
    
    func runTests() {
        testResults = []
        isLoading = true
        addResult(title: "Запуск тестов", status: "🚀", details: "Инициализация соединения с API...")
        validateAPIKey()
    }
    
    private func validateAPIKey() {
        print("Testing API")
        addResult(title: "Проверка API-ключа", status: "⏱️", details: "Проверка API-ключа...")
        
        api.stationsService.getNearestStations(
            lat: 55.75,
            lng: 37.62,
            distance: 10,
            transportTypes: ["train"]
        ) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success:
                    self.updateLastResult(status: "✅", details: "API-ключ действителен")
                    self.testStationSearch()
                case .failure(let error):
                    if case .unauthorized = error {
                        self.updateLastResult(status: "❌", details: "Неверный API-ключ")
                        self.isLoading = false
                    } else {
                        self.updateLastResult(status: "⚠️", details: "Возможно, API-ключ действителен, но произошла ошибка: \(self.formatError(error))")
                        self.testStationSearch()
                    }
                }
            }
        }
    }
    
    private func testStationSearch() {
        print("Поиск станций")
        addResult(title: "Поиск станций", status: "⏱️", details: "Поиск станций в Москве...")
        api.stationsService.searchStations(query: "Москва") { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    let stationCount = self.countStations(in: response)
                    self.updateLastResult(status: "✅", details: "Найдено \(stationCount) станций")
                case .failure(let error):
                    self.updateLastResult(status: "❌", details: "Ошибка: \(self.formatError(error))")
                }
                self.testNearestCity()
            }
        }
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
    
    private func testNearestCity() {
        print("Ближайший город")
        addResult(title: "Ближайший город", status: "⏱️", details: "Поиск ближайшего города...")
        api.settlementService.getNearestCity(lat: 50.440046, lng: 40.4882367, distance: 50) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let city):
                    self.updateLastResult(status: "✅", details: "Ближайший город: \(city.title)")
                case .failure(let error):
                    self.updateLastResult(status: "❌", details: "Ошибка при поиске города: \(self.formatError(error))")
                }
                self.testNearestTrainStation()
            }
        }
    }
    
    private func testNearestTrainStation() {
        print("Ближайшие станции")
        addResult(title: "Ближайшие станции (train_station)", status: "⏱️", details: "Поиск ближайшей станции типа train_station...")
        api.stationsService.getNearestStations(lat: 55.75, lng: 37.62, distance: 5, transportTypes: ["train"]) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    if let trainStation = response.stations.first(where: { $0.stationType == "train_station" }) {
                        self.updateLastResult(status: "✅", details: "Первая станция с типом train_station: \(trainStation.title)")
                    } else {
                        self.updateLastResult(status: "❌", details: "Станция с типом train_station не найдена")
                    }
                case .failure(let error):
                    self.updateLastResult(status: "❌", details: "Ошибка: \(self.formatError(error))")
                }
                self.testStationSchedule()
            }
        }
    }
    
    private func testStationSchedule() {
        print("Расписание станции")
        addResult(title: "Расписание станции", status: "⏱️", details: "Получение расписания для Ленинградского вокзала...")
        
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let tomorrowString = dateFormatter.string(from: tomorrow)
        
        api.scheduleService.getStationSchedule(
            station: "s2000005",
            date: tomorrowString,
            transportTypes: ["train"]
        ) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let schedule):
                    self.updateLastResult(status: "✅", details: "Найдено \(schedule.schedule.count) поездов для \(schedule.station.title)")
                    if let firstTrain = schedule.schedule.first {
                        self.lastThreadUid = firstTrain.thread.uid
                    }
                case .failure(let error):
                    self.updateLastResult(status: "❌", details: "Ошибка: \(self.formatError(error))")
                }
                self.testRouteSearch()
            }
        }
    }
    
    private func testRouteSearch() {
        print("Поиск маршрута")
        addResult(title: "Поиск маршрута", status: "⏱️", details: "Поиск маршрутов из Москвы в Санкт-Петербург...")
        
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let tomorrowString = dateFormatter.string(from: tomorrow)
        
        api.routesService.searchRoutes(
            from: "c213", // Москва
            to: "c2",   // Санкт-Петербург (пример кода)
            date: tomorrowString,
            transportTypes: ["train"]
        ) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let routes):
                    self.updateLastResult(status: "✅", details: "Найдено \(routes.segments.count) маршрутов из \(routes.search.from.title) в \(routes.search.to.title)")
                    if let firstSegment = routes.segments.first {
                        self.lastSearchThreadUid = firstSegment.thread.uid
                        self.addResult(title: "UID маршрута", status: "ℹ️", details: "UID первого thread: \(firstSegment.thread.uid)")
                    }
                case .failure(let error):
                    self.updateLastResult(status: "❌", details: "Ошибка: \(self.formatError(error))")
                }
                self.testThreadInfo()
            }
        }
    }
    
    private func testThreadInfo() {
        print("Поиск нитки")
        guard let uid = self.lastThreadUid else {
            self.updateLastResult(status: "❌", details: "Расписание не содержит поездов для получения uid нитки")
            self.testSpecificCarrier()
            return
        }
        
        addResult(title: "Информация о поезде", status: "⏱️", details: "Получен uid нитки: \(uid). Запрос информации о поезде...")
        
        api.threadService.getThreadInfo(uid: uid) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let threadResponse):
                    self.updateLastResult(status: "✅", details: "Поезд \(threadResponse.thread.title) имеет \(threadResponse.stops.count) остановок. JSON файл получен.")
                    self.lastCarrierCode = threadResponse.thread.carrier.code
                case .failure(let error):
                    self.updateLastResult(status: "❌", details: "Ошибка при получении информации о поезде: \(self.formatError(error))")
                }
                self.testSpecificCarrier()
            }
        }
    }
    
    private func testSpecificCarrier() {
        print("Поиск перевозчика")
        guard let carrierCode = self.lastCarrierCode else {
            self.addResult(title: "Конкретный перевозчик", status: "❌", details: "Код перевозчика не получен из запроса.")
            self.testCopyright()
            return
        }
        
        addResult(title: "Конкретный перевозчик", status: "⏱️", details: "Получение данных для перевозчика с кодом \(carrierCode)...")
        api.carrierService.getCarrierById(code: carrierCode) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let carrier):
                    self.updateLastResult(status: "✅", details: "Получен перевозчик: \(carrier.title)")
                case .failure(let error):
                    self.updateLastResult(status: "❌", details: "Ошибка: \(self.formatError(error))")
                }
                self.testCopyright()
            }
        }
    }
    
    private func testCopyright() {
        print("Поиск копирайта")
        addResult(title: "Копирайт Яндекс Расписаний", status: "⏱️", details: "Получение данных копирайта...")
        api.copyrightService.getCopyright { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let copyrightResponse):
                    let text = copyrightResponse.copyright.text ?? "нет текста"
                    self.updateLastResult(status: "✅", details: "Копирайт получен: \(text)")
                case .failure(let error):
                    self.updateLastResult(status: "❌", details: "Ошибка копирайта: \(self.formatError(error))")
                }
                self.addResult(title: "Тестирование завершено", status: "🎉", details: "Все тесты API завершены")
                self.isLoading = false
            }
        }
    }
    
    private func formatError(_ error: TravelScheduleError) -> String {
        switch error {
        case .invalidURL:
            return "Некорректный URL"
        case .networkError(let err):
            return "Сетевая ошибка: \(err.localizedDescription)"
        case .decodingError(let err):
            return "Ошибка декодирования: \(err)"
        case .serverError(let code):
            return "Ошибка сервера (HTTP \(code))"
        case .noData:
            return "Данные не получены"
        case .unauthorized:
            return "Неавторизован (проверьте API-ключ)"
        case .custom(let message):
            return message
        }
    }
    
    private func addResult(title: String, status: String, details: String) {
        testResults.append(TestResult(title: title, status: status, details: details))
    }
    
    private func updateLastResult(status: String, details: String) {
        guard let lastIndex = testResults.indices.last else { return }
        let lastResult = testResults[lastIndex]
        testResults[lastIndex] = TestResult(title: lastResult.title, status: status, details: details)
    }
}
