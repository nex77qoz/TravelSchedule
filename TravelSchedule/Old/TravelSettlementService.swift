//import Foundation
//
//protocol SettlementService {
//    func getNearestCity(lat: Double, lng: Double, distance: Int) async throws -> City
//}
//
//class TravelSettlementService: SettlementService {
//    private let client: TravelScheduleClient
//    
//    init(client: TravelScheduleClient) {
//        self.client = client
//    }
//    
//    func getNearestCity(lat: Double, lng: Double, distance: Int) async throws -> City {
//        let parameters: [String: Any] = [
//            "format": "json",
//            "lat": lat,
//            "lng": lng,
//            "distance": distance,
//            "lang": "ru_RU"
//        ]
//        let result: Result<City, TravelScheduleError> = await client.request(endpoint: "/nearest_settlement/", parameters: parameters)
//        switch result {
//        case .success(let city):
//            return city
//        case .failure(let error):
//            throw error
//        }
//    }
//}
