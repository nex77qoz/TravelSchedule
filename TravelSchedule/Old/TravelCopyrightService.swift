//import Foundation
//
//protocol CopyrightService {
//    func getCopyright() async throws -> CopyrightResponse
//}
//
//class TravelCopyrightService: CopyrightService {
//    private let client: TravelScheduleClient
//    
//    init(client: TravelScheduleClient) {
//        self.client = client
//    }
//    
//    func getCopyright() async throws -> CopyrightResponse {
//        let parameters: [String: Any] = ["format": "json"]
//        let result: Result<CopyrightResponse, TravelScheduleError> = await client.request(endpoint: "/copyright/", parameters: parameters)
//        switch result {
//        case .success(let response):
//            return response
//        case .failure(let error):
//            throw error
//        }
//    }
//}
