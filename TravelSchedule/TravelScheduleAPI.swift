import Foundation

class YandexScheduleAPI {
    private let apiKey: String
    
    private(set) lazy var stationsService: StationsService = TravelStationsService(client: client)
    private(set) lazy var scheduleService: ScheduleService = TravelScheduleService(client: client)
    private(set) lazy var routesService: RoutesService = TravelRoutesService(client: client)
    private(set) lazy var threadService: ThreadService = TravelThreadService(client: client)
    private(set) lazy var carrierService: CarrierService = TravelCarrierService(client: client)
    
    private lazy var client: TravelScheduleClient = {
        return TravelScheduleClient(apiKey: apiKey)
    }()
    
    init(apiKey: String) {
        self.apiKey = apiKey
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
