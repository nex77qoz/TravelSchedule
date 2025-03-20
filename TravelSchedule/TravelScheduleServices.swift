import Foundation

// MARK: - Service protocols

protocol StationsService {
    func searchStations(query: String, completion: @escaping (Result<StationsResponse, TravelScheduleError>) -> Void)
    func getStationById(code: String, completion: @escaping (Result<Station, TravelScheduleError>) -> Void)
    func getNearestStations(lat: Double, lng: Double, distance: Int, transportTypes: [String], completion: @escaping (Result<NearestStationsResponse, TravelScheduleError>) -> Void)
}

protocol ScheduleService {
    func getStationSchedule(station: String, date: String, transportTypes: [String]?, completion: @escaping (Result<ScheduleResponse, TravelScheduleError>) -> Void)
    func getStationTimetable(station: String, direction: String?, event: String?, completion: @escaping (Result<ScheduleResponse, TravelScheduleError>) -> Void)
}

protocol RoutesService {
    func searchRoutes(from: String, to: String, date: String, transportTypes: [String]?, completion: @escaping (Result<RoutesResponse, TravelScheduleError>) -> Void)
}

protocol ThreadService {
    func getThreadInfo(uid: String, completion: @escaping (Result<ThreadResponse, TravelScheduleError>) -> Void)
}

protocol CarrierService {
    func getCarriersList(code: Int, completion: @escaping (Result<CarriersResponse, TravelScheduleError>) -> Void)
    func getCarrierById(code: Int, completion: @escaping (Result<Carrier, TravelScheduleError>) -> Void)
}

// MARK: - Service implementations

class TravelStationsService: StationsService {
    private let client: TravelScheduleClient
    
    init(client: TravelScheduleClient) {
        self.client = client
    }
    
    func searchStations(query: String, completion: @escaping (Result<StationsResponse, TravelScheduleError>) -> Void) {
        let parameters = ["format": "json", "text": query]
        client.request(endpoint: "/stations_list", parameters: parameters, completion: completion)
    }
    
    func getStationById(code: String, completion: @escaping (Result<Station, TravelScheduleError>) -> Void) {
        let parameters = ["format": "json", "station": code]
        client.request(endpoint: "/station", parameters: parameters, completion: completion)
    }
    
    func getNearestStations(lat: Double, lng: Double, distance: Int, transportTypes: [String], completion: @escaping (Result<NearestStationsResponse, TravelScheduleError>) -> Void) {
        var parameters: [String: Any] = ["format": "json", "lat": lat, "lng": lng, "distance": distance]
        if !transportTypes.isEmpty {
            parameters["transport_types"] = transportTypes.joined(separator: ",")
        }
        client.request(endpoint: "/nearest_stations", parameters: parameters, completion: completion)
    }
}

class TravelScheduleService: ScheduleService {
    private let client: TravelScheduleClient
    
    init(client: TravelScheduleClient) {
        self.client = client
    }
    
    func getStationSchedule(station: String, date: String, transportTypes: [String]?, completion: @escaping (Result<ScheduleResponse, TravelScheduleError>) -> Void) {
        var parameters: [String: Any] = ["format": "json", "station": station]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let _ = dateFormatter.date(from: date) {
            parameters["date"] = date
        } else {
            parameters["date"] = dateFormatter.string(from: Date())
        }
        
        if let transportTypes = transportTypes, !transportTypes.isEmpty {
            parameters["transport_types"] = transportTypes.joined(separator: ",")
        }
        
        client.request(endpoint: "/schedule", parameters: parameters, completion: completion)
    }
    
    func getStationTimetable(station: String, direction: String?, event: String?, completion: @escaping (Result<ScheduleResponse, TravelScheduleError>) -> Void) {
        var parameters: [String: Any] = ["format": "json", "station": station]
        if let direction = direction, !direction.isEmpty {
            parameters["direction"] = direction
        }
        if let event = event, !event.isEmpty {
            parameters["event"] = event
        }
        client.request(endpoint: "/timetable", parameters: parameters, completion: completion)
    }
}

class TravelRoutesService: RoutesService {
    private let client: TravelScheduleClient
    
    init(client: TravelScheduleClient) {
        self.client = client
    }
    
    func searchRoutes(from: String, to: String, date: String, transportTypes: [String]?, completion: @escaping (Result<RoutesResponse, TravelScheduleError>) -> Void) {
        var parameters: [String: Any] = ["format": "json", "from": from, "to": to]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let _ = dateFormatter.date(from: date) {
            parameters["date"] = date
        } else {
            parameters["date"] = dateFormatter.string(from: Date())
        }
        
        if let transportTypes = transportTypes, !transportTypes.isEmpty {
            parameters["transport_types"] = transportTypes.joined(separator: ",")
        }
        
        client.request(endpoint: "/search", parameters: parameters, completion: completion)
    }
}

class TravelThreadService: ThreadService {
    private let client: TravelScheduleClient
    
    init(client: TravelScheduleClient) {
        self.client = client
    }
    
    func getThreadInfo(uid: String, completion: @escaping (Result<ThreadResponse, TravelScheduleError>) -> Void) {
        let parameters = ["format": "json", "uid": uid]
        client.request(endpoint: "/thread", parameters: parameters, completion: completion)
    }
}

class TravelCarrierService: CarrierService {
    private let client: TravelScheduleClient
    
    init(client: TravelScheduleClient) {
        self.client = client
    }
    
    func getCarriersList(code: Int, completion: @escaping (Result<CarriersResponse, TravelScheduleError>) -> Void) {
        let parameters: [String: Any] = [
            "format": "json",
            "code": code
        ]
        print("DEBUG - Calling getCarriersList with parameters: \(parameters)")
        client.request(endpoint: "/carrier", parameters: parameters, completion: completion)
    }
    
    func getCarrierById(code: Int, completion: @escaping (Result<Carrier, TravelScheduleError>) -> Void) {
        let parameters: [String: Any] = [
            "format": "json",
            "code": code
        ]
        
        print("DEBUG - Calling getCarrierById with parameters: \(parameters)")
        
        client.request(endpoint: "/carrier", parameters: parameters) { (result: Result<CarrierResponse, TravelScheduleError>) in
            switch result {
            case .success(let response):
                completion(.success(response.carrier))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
