import Foundation

struct TravelBaseResponse: Decodable {
    let pagination: Pagination?
    
    struct Pagination: Decodable {
        let total: Int
        let limit: Int
        let offset: Int
    }
}

// MARK: - Модель для ближайшего города
struct City: Decodable {
    let distance: Double
    let code: String
    let title: String
    let popularTitle: String?
    let shortTitle: String?
    let lat: Double
    let lng: Double
    let type: String

    enum CodingKeys: String, CodingKey {
        case distance, code, title, lat, lng, type
        case popularTitle = "popular_title"
        case shortTitle = "short_title"
    }
}

// MARK: - Модели для копирайта
struct CopyrightResponse: Decodable {
    let copyright: Copyright
}

struct Copyright: Decodable {
    let logo_vm: String?
    let url: String?
    let logo_vd: String?
    let logo_hy: String?
    let logo_hd: String?
    let logo_vy: String?
    let logo_hm: String?
    let text: String?
}

// MARK: - Station models
struct StationsResponse: Decodable {
    let countries: [Country]?
    let pagination: TravelBaseResponse.Pagination?
    
    struct Country: Decodable {
        let title: String
        let regions: [Region]
    }
    
    struct Region: Decodable {
        let title: String
        let settlements: [Settlement]
    }
    
    struct Settlement: Decodable {
        let title: String
        let stations: [Station]
    }
}

struct Station: Decodable {
    let code: String
    let title: String
    let stationType: String?
    let popularTitle: String?
    let shortTitle: String?
    let transportType: String?
    let longitude: Double?
    let latitude: Double?
    let direction: String?
    let type: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .title)
        
        if container.contains(.code) {
            code = try container.decode(String.self, forKey: .code)
        } else if container.contains(.codes) {
            if let codesContainer = try? container.nestedContainer(keyedBy: CodesKeys.self, forKey: .codes),
               let yandexCode = try? codesContainer.decode(String.self, forKey: .yandexCode) {
                code = yandexCode
            } else {
                code = "unknown"
            }
        } else {
            code = "unknown"
        }
        
        stationType = try container.decodeIfPresent(String.self, forKey: .stationType)
        popularTitle = try container.decodeIfPresent(String.self, forKey: .popularTitle)
        shortTitle = try container.decodeIfPresent(String.self, forKey: .shortTitle)
        transportType = try container.decodeIfPresent(String.self, forKey: .transportType)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        direction = try container.decodeIfPresent(String.self, forKey: .direction)
        
        if let longitudeDouble = try? container.decodeIfPresent(Double.self, forKey: .longitude) {
            longitude = longitudeDouble
        } else if let longitudeString = try? container.decodeIfPresent(String.self, forKey: .longitude),
                  let parsedDouble = Double(longitudeString) {
            longitude = parsedDouble
        } else {
            longitude = nil
        }
        
        if let latitudeDouble = try? container.decodeIfPresent(Double.self, forKey: .latitude) {
            latitude = latitudeDouble
        } else if let latitudeString = try? container.decodeIfPresent(String.self, forKey: .latitude),
                  let parsedDouble = Double(latitudeString) {
            latitude = parsedDouble
        } else {
            latitude = nil
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case code, title, longitude, latitude, direction, type, codes
        case stationType = "station_type"
        case popularTitle = "popular_title"
        case shortTitle = "short_title"
        case transportType = "transport_type"
    }
    
    enum CodesKeys: String, CodingKey {
        case yandexCode = "yandex_code"
    }
}

// MARK: - Schedule models
struct ScheduleResponse: Decodable {
    let date: String
    let station: Station
    let schedule: [ScheduleItem]
    let pagination: TravelBaseResponse.Pagination?
}

struct ScheduleItem: Decodable {
    let arrival: String?
    let departure: String?
    let thread: Thread
    let isFuzzy: Bool?
    let days: String?
    let stops: String?
    let platform: String?
    
    enum CodingKeys: String, CodingKey {
        case arrival, departure, thread, days, stops, platform
        case isFuzzy = "is_fuzzy"
    }
}

// MARK: - Thread/Route information
struct Thread: Decodable {
    let uid: String
    let title: String
    let number: String
    let carrier: Carrier
    let transportType: String
    let vehicle: String?
    let expressType: String?
    
    enum CodingKeys: String, CodingKey {
        case uid, title, number, carrier, vehicle
        case transportType = "transport_type"
        case expressType = "express_type"
    }
}

struct Carrier: Decodable {
    let code: Int
    let title: String
    let codes: CarrierCodes?
    let address: String?
    let url: String?
    let email: String?
    let contacts: String?
    let phone: String?
    let logo: String?
}

struct CarrierCodes: Decodable {
    let icao: String?
    let sirena: String?
    let iata: String?
}

// Carrier response wrapper
struct CarrierResponse: Decodable {
    let carrier: Carrier
}

// MARK: - Search routes between stations
struct RoutesResponse: Decodable {
    let search: SearchInfo
    let segments: [Segment]
    let pagination: TravelBaseResponse.Pagination?
}

struct SearchInfo: Decodable {
    let from: SearchPoint
    let to: SearchPoint
    let date: String
}

struct SearchPoint: Decodable {
    let code: String
    let title: String
    let stationType: String?
    let transportType: String?
    let type: String?
    let popularTitle: String?
    let shortTitle: String?
    
    enum CodingKeys: String, CodingKey {
        case code, title, type, popularTitle = "popular_title", shortTitle = "short_title"
        case stationType = "station_type"
        case transportType = "transport_type"
    }
}

struct Segment: Decodable {
    let arrival: String
    let departure: String
    let from: Station
    let to: Station
    let thread: Thread
    let duration: Int
    let stops: String?
    let departurePlatform: String?
    let arrivalPlatform: String?
    let departureTerm: String?
    let arrivalTerm: String?
    
    enum CodingKeys: String, CodingKey {
        case arrival, departure, from, to, thread, duration, stops
        case departurePlatform = "departure_platform"
        case arrivalPlatform = "arrival_platform"
        case departureTerm = "departure_terminal"
        case arrivalTerm = "arrival_terminal"
    }
}

// MARK: - Thread Information
struct ThreadResponse: Decodable {
    let thread: Thread
    let stops: [StopInfo]
    
    enum CodingKeys: String, CodingKey {
        case thread, stops
    }
    
    enum FlatCodingKeys: String, CodingKey {
        case stops
    }
    
    init(thread: Thread, stops: [StopInfo]) {
        self.thread = thread
        self.stops = stops
    }
    
    init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: CodingKeys.self),
           let threadValue = try? container.decode(Thread.self, forKey: .thread),
           let stopsValue = try? container.decode([StopInfo].self, forKey: .stops) {
            self.thread = threadValue
            self.stops = stopsValue
            return
        }
        
        let thread = try Thread(from: decoder)
        let flatContainer = try decoder.container(keyedBy: FlatCodingKeys.self)
        let stops = try flatContainer.decodeIfPresent([StopInfo].self, forKey: .stops) ?? []
        self.thread = thread
        self.stops = stops
    }
}



// MARK: - Stop Information
struct StopInfo: Decodable {
    let station: Station
    let arrival: String?
    let departure: String?
    let duration: Int?
    let stopTime: Int?
    let platform: String?
    
    enum CodingKeys: String, CodingKey {
        case station, arrival, departure, duration, platform
        case stopTime = "stop_time"
    }
}

// MARK: - Carrier information
struct CarriersResponse: Decodable {
    let carriers: [Carrier]
    let pagination: TravelBaseResponse.Pagination?
}

// MARK: - Nearest stations
struct NearestStationsResponse: Decodable {
    let stations: [Station]
    let pagination: TravelBaseResponse.Pagination?
}
