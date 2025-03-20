import Foundation

class YandexScheduleAPI {
    let stationsService: StationsService
    let scheduleService: ScheduleService
    let routesService: RoutesService
    let threadService: ThreadService
    let carrierService: CarrierService
    let settlementService: SettlementService
    let copyrightService: CopyrightService
    
    private let client: TravelScheduleClient
    
    init(apiKey: String) {
        print("API key: \(apiKey)")
        self.client = TravelScheduleClient(apiKey: apiKey)
        self.stationsService = TravelStationsService(client: client)
        self.scheduleService = TravelScheduleService(client: client)
        self.routesService = TravelRoutesService(client: client)
        self.threadService = TravelThreadService(client: client)
        self.carrierService = TravelCarrierService(client: client)
        self.settlementService = TravelSettlementService(client: client)
        self.copyrightService = TravelCopyrightService(client: client)
    }
    
    func validateAPIKey(completion: @escaping (Bool) -> Void) {
        stationsService.getNearestStations(lat: 55.75, lng: 37.62, distance: 10, transportTypes: ["train"]) { result in
            switch result {
            case .success:
                completion(true)
            case .failure(let error):
                if case .unauthorized = error {
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }
}
