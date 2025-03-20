import Foundation

protocol SettlementService {
    func getNearestCity(lat: Double, lng: Double, distance: Int, completion: @escaping (Result<City, TravelScheduleError>) -> Void)
}

class TravelSettlementService: SettlementService {
    private let client: TravelScheduleClient
    
    init(client: TravelScheduleClient) {
        self.client = client
    }
    
    func getNearestCity(lat: Double, lng: Double, distance: Int, completion: @escaping (Result<City, TravelScheduleError>) -> Void) {
        let parameters: [String: Any] = [
            "format": "json",
            "lat": lat,
            "lng": lng,
            "distance": distance,
            "lang": "ru_RU"
        ]
        client.request(endpoint: "/nearest_settlement/", parameters: parameters, completion: completion)
    }
}
