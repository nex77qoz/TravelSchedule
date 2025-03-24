//import Foundation
//
//// MARK: - Протоколы сервисов
//
//protocol StationsService {
//    func searchStations(query: String) async throws -> StationsResponse
//    func getStationById(code: String) async throws -> Station
//    func getNearestStations(lat: Double, lng: Double, distance: Int, transportTypes: [String]) async throws -> NearestStationsResponse
//}
//
//protocol ScheduleService {
//    func getStationSchedule(station: String, date: String, transportTypes: [String]?) async throws -> ScheduleResponse
//    func getStationTimetable(station: String, direction: String?, event: String?) async throws -> ScheduleResponse
//}
//
//protocol RoutesService {
//    func searchRoutes(from: String, to: String, date: String, transportTypes: [String]?) async throws -> RoutesResponse
//}
//
//protocol ThreadService {
//    func getThreadInfo(uid: String) async throws -> ThreadResponse
//}
//
//protocol CarrierService {
//    func getCarriersList(code: Int) async throws -> CarriersResponse
//    func getCarrierById(code: Int) async throws -> Carrier
//}
//
//// MARK: - Реализация сервисов
//
//class TravelStationsService: StationsService {
//    private let client: TravelScheduleClient
//    
//    init(client: TravelScheduleClient) {
//        self.client = client
//    }
//    
//    func searchStations(query: String) async throws -> StationsResponse {
//        let parameters = ["format": "json", "text": query]
//        let result: Result<StationsResponse, TravelScheduleError> = await client.request(endpoint: "/stations_list", parameters: parameters)
//        switch result {
//        case .success(let response):
//            return response
//        case .failure(let error):
//            throw error
//        }
//    }
//    
//    func getStationById(code: String) async throws -> Station {
//        let parameters = ["format": "json", "station": code]
//        let result: Result<Station, TravelScheduleError> = await client.request(endpoint: "/station", parameters: parameters)
//        switch result {
//        case .success(let station):
//            return station
//        case .failure(let error):
//            throw error
//        }
//    }
//    
//    func getNearestStations(lat: Double, lng: Double, distance: Int, transportTypes: [String]) async throws -> NearestStationsResponse {
//        var parameters: [String: Any] = ["format": "json", "lat": lat, "lng": lng, "distance": distance]
//        if !transportTypes.isEmpty {
//            parameters["transport_types"] = transportTypes.joined(separator: ",")
//        }
//        let result: Result<NearestStationsResponse, TravelScheduleError> = await client.request(endpoint: "/nearest_stations", parameters: parameters)
//        switch result {
//        case .success(let response):
//            return response
//        case .failure(let error):
//            throw error
//        }
//    }
//}
//
//class TravelScheduleService: ScheduleService {
//    private let client: TravelScheduleClient
//    
//    init(client: TravelScheduleClient) {
//        self.client = client
//    }
//    
//    func getStationSchedule(station: String, date: String, transportTypes: [String]?) async throws -> ScheduleResponse {
//        var parameters: [String: Any] = ["format": "json", "station": station]
//        
//        if DateFormatter.apiDateFormatter.date(from: date) != nil {
//            parameters["date"] = date
//        } else {
//            parameters["date"] = DateFormatter.apiDateFormatter.string(from: Date())
//        }
//        
//        if let transportTypes = transportTypes, !transportTypes.isEmpty {
//            parameters["transport_types"] = transportTypes.joined(separator: ",")
//        }
//        
//        let result: Result<ScheduleResponse, TravelScheduleError> = await client.request(endpoint: "/schedule", parameters: parameters)
//        switch result {
//        case .success(let response):
//            return response
//        case .failure(let error):
//            throw error
//        }
//    }
//    
//    func getStationTimetable(station: String, direction: String?, event: String?) async throws -> ScheduleResponse {
//        var parameters: [String: Any] = ["format": "json", "station": station]
//        if let direction = direction, !direction.isEmpty {
//            parameters["direction"] = direction
//        }
//        if let event = event, !event.isEmpty {
//            parameters["event"] = event
//        }
//        let result: Result<ScheduleResponse, TravelScheduleError> = await client.request(endpoint: "/timetable", parameters: parameters)
//        switch result {
//        case .success(let response):
//            return response
//        case .failure(let error):
//            throw error
//        }
//    }
//}
//
//class TravelRoutesService: RoutesService {
//    private let client: TravelScheduleClient
//    
//    init(client: TravelScheduleClient) {
//        self.client = client
//    }
//    
//    func searchRoutes(from: String, to: String, date: String, transportTypes: [String]?) async throws -> RoutesResponse {
//        var parameters: [String: Any] = ["format": "json", "from": from, "to": to]
//        
//        if DateFormatter.apiDateFormatter.date(from: date) != nil {
//            parameters["date"] = date
//        } else {
//            parameters["date"] = DateFormatter.apiDateFormatter.string(from: Date())
//        }
//        
//        if let transportTypes = transportTypes, !transportTypes.isEmpty {
//            parameters["transport_types"] = transportTypes.joined(separator: ",")
//        }
//        
//        let result: Result<RoutesResponse, TravelScheduleError> = await client.request(endpoint: "/search", parameters: parameters)
//        switch result {
//        case .success(let response):
//            return response
//        case .failure(let error):
//            throw error
//        }
//    }
//}
//
//class TravelThreadService: ThreadService {
//    private let client: TravelScheduleClient
//    
//    init(client: TravelScheduleClient) {
//        self.client = client
//    }
//    
//    func getThreadInfo(uid: String) async throws -> ThreadResponse {
//        let parameters = ["format": "json", "uid": uid]
//        let result: Result<ThreadResponse, TravelScheduleError> = await client.request(endpoint: "/thread", parameters: parameters)
//        switch result {
//        case .success(let response):
//            return response
//        case .failure(let error):
//            throw error
//        }
//    }
//}
//
//class TravelCarrierService: CarrierService {
//    private let client: TravelScheduleClient
//    
//    init(client: TravelScheduleClient) {
//        self.client = client
//    }
//    
//    func getCarriersList(code: Int) async throws -> CarriersResponse {
//        let parameters: [String: Any] = ["format": "json", "code": code]
//        let result: Result<CarriersResponse, TravelScheduleError> = await client.request(endpoint: "/carrier", parameters: parameters)
//        switch result {
//        case .success(let response):
//            return response
//        case .failure(let error):
//            throw error
//        }
//    }
//    
//    func getCarrierById(code: Int) async throws -> Carrier {
//        let parameters: [String: Any] = ["format": "json", "code": code]
//        let result: Result<CarrierResponse, TravelScheduleError> = await client.request(endpoint: "/carrier", parameters: parameters)
//        switch result {
//        case .success(let response):
//            return response.carrier
//        case .failure(let error):
//            throw error
//        }
//    }
//}
