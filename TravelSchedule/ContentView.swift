import SwiftUI

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
    let status: String // "✅", "❌", "⏱️"
    let details: String
}

class TravelScheduleViewModel: ObservableObject {
    private let api = YandexScheduleAPI(apiKey: "0644a1c7-41cd-46e3-98cc-e2607268dea6")
    
    @Published var testResults: [TestResult] = []
    @Published var isLoading: Bool = false
    
    func runTests() {
        testResults = []
        isLoading = true
        addResult(title: "Запуск тестов", status: "🚀", details: "Инициализация соединения с API...")
        
        validateAPIKey()
    }
    
    private func validateAPIKey() {
        addResult(title: "Проверка API-ключа", status: "⏱️", details: "Проверка API-ключа...")
        
        api.stationsService.getNearestStations(
            lat: 55.75,
            lng: 37.62,
            distance: 5,
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
                    } else {
                        self.updateLastResult(status: "⚠️", details: "Возможно, API-ключ действителен, но произошла ошибка: \(self.formatError(error))")
                        self.testStationSearch()
                    }
                }
            }
        }
    }
    
    private func testStationSearch() {
        addResult(title: "Поиск станции", status: "⏱️", details: "Поиск станций в Москве...")
        
        api.stationsService.searchStations(query: "Москва") { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    let stationCount = self.countStations(in: response)
                    self.updateLastResult(status: "✅", details: "Найдено \(stationCount) станций")
                    
                case .failure(let error):
                    self.updateLastResult(status: "❌", details: "Ошибка: \(self.formatError(error))")
                    if case .decodingError(let err) = error {
                        print("Детали ошибки декодирования: \(err)")
                    }
                }
                
                self.testNearestStations()
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
    
    private func testNearestStations() {
        addResult(title: "Ближайшие станции", status: "⏱️", details: "Поиск станций рядом с центром Москвы...")
        
        api.stationsService.getNearestStations(
            lat: 55.75,
            lng: 37.62,
            distance: 5,
            transportTypes: ["train"]
        ) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    self.updateLastResult(status: "✅", details: "Найдено \(response.stations.count) ближайших станций")
                    
                case .failure(let error):
                    self.updateLastResult(status: "❌", details: "Ошибка: \(self.formatError(error))")
                }
                
                self.testStationSchedule()
            }
        }
    }
    
    private func testStationSchedule() {
        addResult(title: "Расписание станции", status: "⏱️", details: "Получение расписания для Ленинградского вокзала...")
        
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let tomorrowString = dateFormatter.string(from: tomorrow)
        
        api.scheduleService.getStationSchedule(
            station: "s9600213", // Москва (Ленинградский вокзал)
            date: tomorrowString,
            transportTypes: ["train"]
        ) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let schedule):
                    self.updateLastResult(status: "✅", details: "Найдено \(schedule.schedule.count) поездов для \(schedule.station.title)")
                    
                case .failure(let error):
                    self.updateLastResult(status: "❌", details: "Ошибка: \(self.formatError(error))")
                }
                
                self.testRouteSearch()
            }
        }
    }
    
    private func testRouteSearch() {
        addResult(title: "Поиск маршрута", status: "⏱️", details: "Поиск маршрутов из Москвы в Санкт-Петербург...")
        
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let tomorrowString = dateFormatter.string(from: tomorrow)
        
        api.routesService.searchRoutes(
            from: "c213", // Москва
            to: "c2", // Санкт-Петербург
            date: tomorrowString,
            transportTypes: ["train"]
        ) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let routes):
                    self.updateLastResult(status: "✅", details: "Найдено \(routes.segments.count) маршрутов из \(routes.search.from.title) в \(routes.search.to.title)")
                    
                case .failure(let error):
                    self.updateLastResult(status: "❌", details: "Ошибка: \(self.formatError(error))")
                }
                
                self.testThreadInfo()
            }
        }
    }
    
    private func testThreadInfo() {
        addResult(title: "Информация о поезде", status: "⏱️", details: "Получение информации о поезде...")
        
        let threadIDs = [
            "050Ч_8_2", // Сапсан
            "030А_0_2", // Grand Express
            "059А_8_2"  // Премиум поезд
        ]
        
        tryNextThreadID(threadIDs: threadIDs, index: 0)
    }

    private func tryNextThreadID(threadIDs: [String], index: Int) {
        guard index < threadIDs.count else {
            self.updateLastResult(status: "❌", details: "Не удалось найти действительный идентификатор поезда")
            self.testCarriersList()
            return
        }
        
        let threadID = threadIDs[index]
        
        api.threadService.getThreadInfo(uid: threadID) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let thread):
                    self.updateLastResult(
                        status: "✅",
                        details: "Поезд \(thread.thread.title) имеет \(thread.stops.count) остановок"
                    )
                    self.testCarriersList()
                    
                case .failure:
                    self.tryNextThreadID(threadIDs: threadIDs, index: index + 1)
                }
            }
        }
    }
    
    private func testCarriersList() {
        addResult(title: "Список перевозчиков", status: "⏱️", details: "Получение списка перевозчиков...")
        
        api.carrierService.getCarriersList { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let carriers):
                    self.updateLastResult(
                        status: "✅",
                        details: "Найдено \(carriers.carriers.count) перевозчиков"
                    )
                    
                case .failure(let error):
                    self.updateLastResult(
                        status: "❌",
                        details: "Ошибка: \(self.formatError(error))"
                    )
                }
                
                self.testSpecificCarrier()
            }
        }
    }
    
    private func testSpecificCarrier() {
        addResult(title: "Конкретный перевозчик", status: "⏱️", details: "Получение данных для РЖД...")
        
        api.carrierService.getCarrierById(code: 680) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let carrier):
                    self.updateLastResult(status: "✅", details: "Получен перевозчик: \(carrier.title)")
                    
                case .failure(let error):
                    self.updateLastResult(status: "❌", details: "Ошибка: \(self.formatError(error))")
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
