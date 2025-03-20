import Foundation

protocol CopyrightService {
    func getCopyright(completion: @escaping (Result<CopyrightResponse, TravelScheduleError>) -> Void)
}

class TravelCopyrightService: CopyrightService {
    private let client: TravelScheduleClient
    
    init(client: TravelScheduleClient) {
        self.client = client
    }
    
    func getCopyright(completion: @escaping (Result<CopyrightResponse, TravelScheduleError>) -> Void) {
        let parameters: [String: Any] = [
            "format": "json"
        ]
        client.request(endpoint: "/copyright/", parameters: parameters, completion: completion)
    }
}
